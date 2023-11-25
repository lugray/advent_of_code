#!/usr/bin/env ruby

require_relative 'day'

class Day22 < Day
  class Cell
    attr_accessor :r, :c, :up, :down, :left, :right, :cube_up, :cube_down, :cube_left, :cube_right

    def initialize(r, c, type)
      @r = r
      @c = c
      @type = type
    end

    def wall?
      @type == '#'
    end

    def naturual_connection?(direction)
      case direction
      when :right then @right.c == @c + 1
      when :down then @down.r == @r + 1
      when :left then @left.c == @c - 1
      when :up then @up.r == @r - 1
      when :right_down
        cl = @right.down
        cl&.r == @r + 1 && cl&.c == @c + 1
      when :left_down
        cl = @left.down
        cl&.r == @r + 1 && cl&.c == @c - 1
      when :left_up
        cl = @left.up
        cl&.r == @r - 1 && cl&.c == @c - 1
      when :right_up
        cl = @right.up
        cl&.r == @r - 1 && cl&.c == @c + 1
      end
    end

    def empty_connections
      [:right, :down, :left, :up].reject(&method(:naturual_connection?))
    end

    def empty_diagonals
      [:right_down, :left_down, :left_up, :right_up].reject(&method(:naturual_connection?))
    end

    def outside_corner?
      empty_connections.count == 2
    end

    def inside_corner?
      empty_connections.count == 0 && empty_diagonals.count == 1
    end

    def clockwise
      @clockwise ||= begin
        case empty_connections
        when [:up] then right
        when [:right] then down
        when [:down] then left
        when [:left] then up
        when [:right, :up] then down
        when [:down, :left] then up
        when [:left, :up] then right
        when [:right, :down] then left
        when []
          case empty_diagonals
          when [:right_down] then down
          when [:left_down] then left
          when [:left_up] then up
          when [:right_up] then right
          end
        end
      end
    end

    def counterclockwise
      @counterclockwise ||= begin
        case empty_connections
        when [:up] then left
        when [:right] then up
        when [:down] then right
        when [:left] then down
        when [:right, :up] then left
        when [:down, :left] then right
        when [:left, :up] then down
        when [:right, :down] then up
        when []
          case empty_diagonals
          when [:right_down] then right
          when [:left_down] then down
          when [:left_up] then left
          when [:right_up] then up
          end
        end
      end
    end
  end

  def initialize
    @max_r = 0
    @max_c = 0
    @grid = {}
    @start = nil
    grid, directions = input.split("\n\n")
    @directions = directions.chomp
    grid.each_line.each_with_index do |line, r|
      @max_r = [r, @max_r].max
      line.chomp.each_char.each_with_index do |char, c|
        @max_c = [c, @max_c].max
        @grid[[r, c]] = Cell.new(r, c, char) unless char == ' '
        if !@start && char == '.'
          @start = @grid[[r, c]]
        end
      end
    end
    connect_flat
    connect_cube
  end

  def connect_flat
    0.upto(@max_r) do |r|
      c = 0
      last_cell = nil
      until last_cell = @grid[[r, c]]
        c += 1
      end
      first_cell = last_cell
      while c <= @max_c
        if cell = @grid[[r, c]]
          join_h(last_cell, cell)
          last_cell = cell
        end
        c += 1
      end
      join_h(last_cell, first_cell)
    end
    0.upto(@max_c) do |c|
      r = 0
      last_cell = nil
      until last_cell = @grid[[r, c]]
        r += 1
      end
      first_cell = last_cell
      while r <= @max_r
        if cell = @grid[[r, c]]
          join_v(last_cell, cell)
          last_cell = cell
        end
        r += 1
      end
      join_v(last_cell, first_cell)
    end
  end

  def connect_cube
    cell = @start
    inside_corners = []
    loop do
      if cell.inside_corner?
        inside_corners << cell
      end
      cell = cell.clockwise
      break if cell == @start
    end
    inside_corners.each do |cell|
      cw = cell.clockwise
      cc = cell.counterclockwise
      rounding = false
      cw_out_dir = cw.empty_connections.first
      cc_out_dir = cc.empty_connections.first
      cw_in_dir = reverse_dir(cw_out_dir)
      cc_in_dir = reverse_dir(cc_out_dir)
      loop do
        cw.send("cube_#{cw_out_dir}=", [cc, cc_in_dir])
        cc.send("cube_#{cc_out_dir}=", [cw, cw_in_dir])
        if cw.outside_corner? && cc.outside_corner?
          break
        elsif cw.outside_corner? && !rounding
          rounding = true
          cw_out_dir = cw.empty_connections.find { |dir| dir != cw_out_dir }
          cw_in_dir = reverse_dir(cw_out_dir)
          cc = cc.counterclockwise
        elsif cc.outside_corner? && !rounding
          rounding = true
          cc_out_dir = cc.empty_connections.find { |dir| dir != cc_out_dir }
          cc_in_dir = reverse_dir(cc_out_dir)
          cw = cw.clockwise
        else
          cw = cw.clockwise
          cc = cc.counterclockwise
          rounding = false
        end
      end
    end
  end

  def reverse_dir(dir)
    case dir
    when :right then :left
    when :down then :up
    when :left then :right
    when :up then :down
    end
  end

  def join_h(cell1, cell2)
    cell1.right = cell2
    cell2.left = cell1
  end

  def join_v(cell1, cell2)
    cell1.down = cell2
    cell2.up = cell1
  end

  def facing(direction)
    case direction
    when :right then 0
    when :down then 1
    when :left then 2
    when :up then 3
    end
  end

  def turn(direction, instruction)
    case instruction
    when 'L'
      case direction
      when :right then return :up
      when :up then return :left
      when :left then return :down
      when :down then return :right
      end
    when 'R'
      case direction
      when :right then return :down
      when :down then return :left
      when :left then return :up
      when :up then return :right
      end
    end
  end

  def cube_go(cell, direction)
    nc, nd = cell.send("cube_#{direction}")
    unless nc
      nc = cell.send(direction)
      nd = direction
    end
    [nc, nd]
  end

  def part_1
    direction = :right
    cell = @start
    @directions.scan(/[LR]|\d+/).each do |instruction|
      case instruction
      when 'L', 'R'
        direction = turn(direction, instruction)
      else
        instruction.to_i.times do
          nc = cell.send(direction)
          break if nc.wall?
          cell = nc
        end
      end
    end
    1000 * (cell.r + 1) + 4 * (cell.c + 1) + facing(direction)
  end

  def part_2
    direction = :right
    cell = @start
    @directions.scan(/[LR]|\d+/).each do |instruction|
      case instruction
      when 'L', 'R'
        direction = turn(direction, instruction)
      else
        instruction.to_i.times do
          nc, nd = cube_go(cell, direction)
          break if nc.wall?
          cell = nc
          direction = nd
        end
      end
    end
    1000 * (cell.r + 1) + 4 * (cell.c + 1) + facing(direction)
  end
end

Day22.run if __FILE__ == $0

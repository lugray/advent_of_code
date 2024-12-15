#!/usr/bin/env ruby

require_relative 'day'

class Day15 < Day
  WALL = '#'
  OPEN = '.'
  BOX = 'O'
  ROBOT = '@'
  def initialize
    @map = {}
    map, instructions = input_paragraphs
    @instructions = instructions.each_line(chomp: true).to_a.join
    map.each_line.each_with_index do |line, row|
      line.each_char.each_with_index do |char, col|
        if char == ROBOT
          @robot = [row, col]
          char = OPEN
        end
        @map[[row, col]] = char
      end
    end
    @mr = map.each_line.count - 1
    @mc = map.each_line.first.length - 1
  end

  def part_1
    @instructions.each_char do |instruction|
      case instruction
      when '^'
        open_row = (@robot[0]-1).downto(0).find do |row|
          case @map[[row, @robot[1]]]
          when WALL then break nil
          when BOX then false
          when OPEN then true
          end
        end
        if open_row
          r = @robot[0] -= 1
          c = @robot[1]
          @map[[r, c]], @map[[open_row, c]] = @map[[open_row, c]], @map[[r, c]]
        end
      when 'v'
        open_row = (@robot[0]+1).upto(@mr).find do |row|
          case @map[[row, @robot[1]]]
          when WALL then break nil
          when BOX then false
          when OPEN then true
          end
        end
        if open_row
          r = @robot[0] += 1
          c = @robot[1]
          @map[[r, c]], @map[[open_row, c]] = @map[[open_row, c]], @map[[r, c]]
        end
      when '<'
        open_col = (@robot[1]-1).downto(0).find do |col|
          case @map[[@robot[0], col]]
          when WALL then break nil
          when BOX then false
          when OPEN then true
          end
        end
        if open_col
          r = @robot[0]
          c = @robot[1] -= 1
          @map[[r, c]], @map[[r, open_col]] = @map[[r, open_col]], @map[[r, c]]
        end
      when '>'
        open_col = (@robot[1]+1).upto(@mc).find do |col|
          case @map[[@robot[0], col]]
          when WALL then break nil
          when BOX then false
          when OPEN then true
          end
        end
        if open_col
          r = @robot[0]
          c = @robot[1] += 1
          @map[[r, c]], @map[[r, open_col]] = @map[[r, open_col]], @map[[r, c]]
        end
      end
    end
    @map.sum do |(row, col), char|
      next 0 unless char == BOX
      100 * row + col
    end
  end

  def part_2
  end
end

Day15.run if __FILE__ == $0

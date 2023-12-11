#!/usr/bin/env ruby

require_relative 'day'

class Day10 < Day
  class Visitor
    attr_reader :pos, :prev

    def initialize(map, pos, prev)
      @map = map
      @pos = pos
      @prev = prev
    end

    def step
      prev = @pos
      @pos = self.next
      @prev = prev
    end

    def left
      [@pos[0], @pos[1] - 1]
    end

    def right
      [@pos[0], @pos[1] + 1]
    end

    def up
      [@pos[0] - 1, @pos[1]]
    end

    def down
      [@pos[0] + 1, @pos[1]]
    end

    def joins
      case @map[@pos]
      when '-' then [left, right]
      when '|' then [up, down]
      when 'F' then [down, right]
      when '7' then [down, left]
      when 'L' then [up, right]
      when 'J' then [up, left]
      end
    end

    def next
      joins.reject { |p| p == @prev }.first
    end
  end

  def initialize
    @map = {}
    input_lines.each_with_index.map do |line, r|
      line.each_char.each_with_index.map do |char, c|
        @map[[r, c]] = char
        @start = [r, c] if char == 'S'
      end
    end
  end

  def part_1
    s = Visitor.new(@map, @start, nil)
    visitors = [s.left, s.right, s.up, s.down].map { |p| Visitor.new(@map, p, s.pos) }
    visitors.select! { |v| v.joins&.include?(s.pos) }
    (1..).each do |i|
      return i if visitors.first.pos == visitors.last.pos
      visitors.each { |v| v.step }
    end
  end

  def double(pos)
    [pos[0] * 2, pos[1] * 2]
  end

  def between(pos1, pos2)
    [pos1[0] + pos2[0], pos1[1] + pos2[1]]
  end

  def flood(colouring, pos, colour, min_r:, max_r:, min_c:, max_c:)
    return if colouring[pos]
    pos_list = [pos]
    until pos_list.empty?
      pos = pos_list.shift
      next if colouring[pos]
      next if pos[0] < min_r || pos[0] > max_r || pos[1] < min_c || pos[1] > max_c
      colouring[pos] = colour
      pos_list << [pos[0] - 1, pos[1]]
      pos_list << [pos[0] + 1, pos[1]]
      pos_list << [pos[0], pos[1] - 1]
      pos_list << [pos[0], pos[1] + 1]
    end
  end

  def part_2
    colouring = {}
    s = Visitor.new(@map, @start, nil)
    colouring[double(s.pos)] = :path
    visitors = [s.left, s.right, s.up, s.down].map { |p| Visitor.new(@map, p, s.pos) }
    visitors.select! { |v| v.joins&.include?(s.pos) }
    visitors.each do |visitor|
      colouring[between(visitor.pos, visitor.prev)] = :path
      colouring[double(visitor.pos)] = :path
    end
    loop do
      visitors.each do |visitor|
        visitor.step
        colouring[between(visitor.pos, visitor.prev)] = :path
        colouring[double(visitor.pos)] = :path
      end
      break if visitors.first.pos == visitors.last.pos
    end
    min_r, max_r = @map.keys.map(&:first).minmax
    min_c, max_c = @map.keys.map(&:last).minmax
    min_r -= 2
    min_c -= 2
    max_r = max_r * 2 + 2
    max_c = max_c * 2 + 2
    flood(colouring, [min_r, min_c], :outside, min_r:, max_r:, min_c:, max_c:)
    min_r.step(max_r, 2).sum do |r|
      min_c.step(max_c, 2).count do |c|
        colouring[[r, c]].nil?
      end
    end
  end
end

Day10.run if __FILE__ == $0

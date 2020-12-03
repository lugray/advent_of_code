#!/usr/bin/env ruby

require_relative 'day'

class Map
  def initialize(input)
    @map = input.lines.map do |line|
      line.chomp.each_char.map { |c| c == '#' }
    end
    @rows = @map.size
    @cols = @map.first.size
  end

  def diagonal_count(right, down)
    (0...@rows).step(down).zip((0..).step(right)).count do |row, col|
      tree_at(row, col)
    end
  end

  private

  def tree_at(row, col)
    raise "#{row} is larger than #{@rows - 1}" if row >= @rows
    @map[row][col % @cols]
  end
end

class Day03 < Day
  def initialize
    @map = Map.new(input)
  end

  def part_1
    @map.diagonal_count(3, 1)
  end

  def part_2
    [
      @map.diagonal_count(1, 1),
      @map.diagonal_count(3, 1),
      @map.diagonal_count(5, 1),
      @map.diagonal_count(7, 1),
      @map.diagonal_count(1, 2),
    ].inject(:*)
  end
end

Day03.run if __FILE__ == $0

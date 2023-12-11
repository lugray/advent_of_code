#!/usr/bin/env ruby

require_relative 'day'

class Day11 < Day
  def initialize
    @galaxies = []
    input.each_line(chomp: true).each_with_index.map do |line, row|
      line.each_char.each_with_index.map do |char, col|
        @galaxies << [row, col] if char == '#'
      end
    end
    @max_row = input.each_line(chomp: true).count
    @max_col = input.each_line(chomp: true).first.length
    @empty_rows = (0...@max_row).reject { |row| @galaxies.any? { |galaxy| galaxy[0] == row } }
    @empty_cols = (0...@max_col).reject { |col| @galaxies.any? { |galaxy| galaxy[1] == col } }
  end

  def distance_sum(expansion_factor: 2)
    @galaxies.combination(2).sum do |(row1, col1), (row2, col2)|
      row1, row2 = [row1, row2].sort
      col1, col2 = [col1, col2].sort
      (row1...row2).sum { |row| @empty_rows.include?(row) ? expansion_factor : 1 } + (col1...col2).sum { |col| @empty_cols.include?(col) ? expansion_factor : 1 }
    end
  end

  def part_1
    distance_sum
  end

  def part_2
    distance_sum(expansion_factor: 1000000)
  end
end

Day11.run if __FILE__ == $0

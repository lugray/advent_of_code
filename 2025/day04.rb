#!/usr/bin/env ruby

require_relative 'day'

class Day04 < Day
  class RollSet < Set
    def count_around(pos)
      r, c = pos
      [
        [r-1, c-1], [r-1, c], [r-1, c+1],
        [r,   c-1],           [r,   c+1],
        [r+1, c-1], [r+1, c], [r+1, c+1],
      ].count { |p| include?(p) }
    end

    def moveable?(pos) = count_around(pos) < 4
  end

  def initialize
    @rolls = each_input_grid_pos.each_with_object(RollSet.new) do |(row, col, char), s|
      s << [row, col] if char == '@'
    end
  end

  def part_1
    @rolls.count(&@rolls.method(:moveable?))
  end

  def part_2
    rolls = @rolls.dup
    while rolls.any?(&rolls.method(:moveable?))
      rolls.delete_if(&rolls.method(:moveable?))
    end
    @rolls.length - rolls.length
  end
end

Day04.run if __FILE__ == $0

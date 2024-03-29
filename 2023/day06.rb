#!/usr/bin/env ruby

require_relative 'day'

class Day06 < Day
  def initialize
    @times, @distances = input_lines(&:ints)
  end

  def rekern(ints) = ints.map(&:to_s).join.to_i

  def ways_to_win(t, d)
    min_hold, max_hold = quadratic(1, -t, d + 1)
    max_hold.floor - min_hold.ceil + 1
  end

  def part_1
    @times.zip(@distances).map { |t, d| ways_to_win(t, d) }.inject(:*)
  end

  def part_2
    ways_to_win(rekern(@times), rekern(@distances))
  end
end

Day06.run if __FILE__ == $0

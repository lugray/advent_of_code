#!/usr/bin/env ruby

require_relative 'day'

class Day10 < Day
  def initialize
    @adapters = input.each_line.map(&:to_i).sort
    @count_options = {}
  end

  def part_1
    differences = @adapters.dup.unshift(0).push(@adapters.last+3).each_cons(2).map { |a, b| b-a }.tally
    differences[3] * differences[1]
  end

  def part_2
    count_options
  end

  def count_options(start = 0)
    @count_options[start] ||= begin
      next_starts = @adapters.select { |n| n.between?(start + 1,  start + 3) }
      return 1 if next_starts.empty?
      next_starts.sum { |s| count_options(s) }
    end
  end
end

Day10.run if __FILE__ == $0

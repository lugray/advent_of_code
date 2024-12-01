#!/usr/bin/env ruby

require_relative 'day'

class Day01 < Day
  def initialize
    @lists = input_grid(&:to_i).transpose
  end

  def part_1
    @lists.map(&:sort).transpose.sum { |a, b| (a - b).abs }
  end

  def part_2
    counts = @lists.last.tally
    @lists.first.sum { |n| n * counts.fetch(n, 0) }
  end
end

Day01.run if __FILE__ == $0

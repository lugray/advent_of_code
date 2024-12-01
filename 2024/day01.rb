#!/usr/bin/env ruby

require_relative 'day'

class Day01 < Day
  def initialize
    @lists = input_grid(&:to_i).transpose.each(&:sort!)
  end

  def part_1
    @lists.transpose.sum { |a, b| (a - b).abs }
  end

  def part_2
    counts = Hash.new(0)
    @lists.last.each { |n| counts[n] += 1 }
    @lists.first.sum { |n| n * counts[n] }
  end
end

Day01.run if __FILE__ == $0

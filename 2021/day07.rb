#!/usr/bin/env ruby

require_relative 'day'

class Day07 < Day
  def initialize
    @positions = input_numbers
  end

  def fuel_to(p)
    @positions.sum { |x| (x - p).abs }
  end

  def real_fuel_to(p)
    @positions.sum do |x|
      d = (x - p).abs
      d * (d + 1) / 2
    end
  end

  def candidates
    Range.new(*@positions.minmax)
  end

  def part_1
    candidates.map(&method(:fuel_to)).min
  end

  def part_2
    candidates.map(&method(:real_fuel_to)).min
  end
end

Day07.run if __FILE__ == $0

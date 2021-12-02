#!/usr/bin/env ruby

require_relative 'day'

class Day01 < Day
  def initialize
    @depths = input_numbers
  end

  def part_1
    @depths.each_cons(2).count { |a, b| b > a }
  end

  def part_2
    @depths.each_cons(4).count { |a, _, _, b| b > a }
  end
end

Day01.run if __FILE__ == $0

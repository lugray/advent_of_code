#!/usr/bin/env ruby

require_relative 'day'

class Day06 < Day
  def initialize
    @lines = input_lines
  end

  def part_1
    ops = @lines.last.split
    nums = @lines[...-1].map(&:ints)
    nums.transpose.zip(ops).sum do |nums, op|
      nums.inject(op)
    end
  end

  def part_2
    @lines.
      map { |l| l.each_char.to_a }.
      transpose.map(&:join).
      join("\n").
      gsub(' ', '').
      split("\n\n").
      sum do |equation|
        nums = equation.split("\n")
        op = nums.first[-1]
        nums.map!(&:to_i).inject(op)
      end
  end
end

Day06.run if __FILE__ == $0

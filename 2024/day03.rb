#!/usr/bin/env ruby

require_relative 'day'

class Day03 < Day
  def initialize
    @instructions = input
  end

  def part_1
    @instructions.scan(/mul\((\d+),(\d+)\)/).map { |a, b| a.to_i * b.to_i }.sum
  end

  def part_2
    enabled = true
    @instructions.scan(/mul\((\d+),(\d+)\)|(do\(\))|(don't\(\))/).map do |a, b, enable, disable|
      if enable
        enabled = true
        0
      elsif disable
        enabled = false
        0
      elsif enabled
        a.to_i * b.to_i
      else
        0
      end
    end.sum
  end
end

Day03.run if __FILE__ == $0

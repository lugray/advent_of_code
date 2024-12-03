#!/usr/bin/env ruby

require_relative 'day'

MUL = /mul\((\d+),(\d+)\)/
TOGGLE = /(do\(\)|don't\(\))/

class Day03 < Day
  def initialize
    @instructions = input
  end

  def part_1
    @instructions.scan(MUL).sum { |a, b| a.to_i * b.to_i }
  end

  def part_2
    enabled = true
    @instructions.scan(/#{MUL}|#{TOGGLE}/).sum do |a, b, toggle|
      enabled = (toggle == 'do()') and next 0 if toggle
      enabled ? a.to_i * b.to_i : 0
    end
  end
end

Day03.run if __FILE__ == $0

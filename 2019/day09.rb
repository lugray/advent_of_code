#!/usr/bin/env ruby

require_relative 'day'
require_relative 'intcode'

class Day09 < Day
  def part_1
    Intcode.new(input.split(',').map(&:to_i)).with_inputs(1).run.outputs
  end

  def part_2
    Intcode.new(input.split(',').map(&:to_i)).with_inputs(2).run.outputs
  end
end

Day09.run if __FILE__ == $0

#!/usr/bin/env ruby

require_relative 'day'
require_relative 'intcode'

class Day05 < Day
  def part_1
    Intcode.new(input.split(',').map(&:to_i)).with_inputs(1).run.outputs.last
  end

  def part_2
    Intcode.new(input.split(',').map(&:to_i)).with_inputs(5).run.outputs.last
  end
end

Day05.run if __FILE__ == $0

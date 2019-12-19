#!/usr/bin/env ruby

require_relative 'day'
require_relative 'intcode'

class Day19 < Day
  def part_1
    intcode = Intcode.new(input.split(',').map(&:to_i))
    (0...50).sum do |x|
      (0...50).sum do |y|
        intcode.dup.with_inputs(x, y).run.outputs.shift
      end
    end
  end

  def part_2
    intcode = Intcode.new(input.split(',').map(&:to_i))
    x, y = 0, 0
    loop do
      x += 1
      loop do
        break if intcode.dup.with_inputs(x+99, y).run.outputs.shift == 1
        y += 1
      end
      break if intcode.dup.with_inputs(x, y+99).run.outputs.shift == 1
    end
    x * 10000 + y
  end
end

Day19.run if __FILE__ == $0

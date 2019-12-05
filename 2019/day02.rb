#!/usr/bin/env ruby

require_relative 'aoc'
require_relative 'intcode'

class Day02 < Day
  def part_1
    Intcode.new(AOC.input.split(',').map(&:to_i)).with(1 => 12, 2 => 2).run.value_at(0)
  end

  def part_2
    intcode = Intcode.new(AOC.input.split(',').map(&:to_i))
    (0..99).each do |noun|
      (0..99).each do |verb|
        if intcode.dup.with(1 => noun, 2 => verb).run.value_at(0) == 19690720
          return 100 * noun + verb
        end
      end
    end
  end
end

Day02.run if __FILE__ == $0

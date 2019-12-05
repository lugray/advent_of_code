#!/usr/bin/env ruby

require_relative 'aoc'
require_relative 'intcode'

intcode = Intcode.new(AOC.input.split(',').map(&:to_i))
puts intcode.dup.with(1 => 12, 2 => 2).run.value_at(0)
(0..99).each do |noun|
  (0..99).each do |verb|
    if intcode.dup.with(1 => noun, 2 => verb).run.value_at(0) == 19690720
      puts 100 * noun + verb
      break 2
    end
  end
end

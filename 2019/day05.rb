#!/usr/bin/env ruby

require_relative 'aoc'
require_relative 'intcode'

intcode = Intcode.new(AOC.input.split(',').map(&:to_i))
intcode.dup.with_inputs(1).run
intcode.dup.with_inputs(5).run

#!/usr/bin/env ruby

require_relative 'day'
require_relative 'computer'

class Day08 < Day
  def initialize
    @computer = Computer.new(input)
  end

  def part_1
    @computer.each_step(&:track_inst).halt_when(&:dup_inst?).run.accumulator
  end

  def part_2
    @computer.jmp_nop_swaps.find(&:halts?).accumulator
  end
end

Day08.run if __FILE__ == $0

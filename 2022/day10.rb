#!/usr/bin/env ruby

require_relative 'day'

class Day10 < Day
  REL_CYCLES = [20, 60, 100, 140, 180, 220]

  def initialize
    @program = input_grid
  end

  def each_cycle
    return enum_for(:each_cycle) unless block_given?
    cycle = 0
    x = 1
    @program.each do |line|
      case line
      in ['noop']
        yield(x, cycle += 1)
      in ['addx', dx]
        yield(x, cycle += 1)
        yield(x, cycle += 1)
        x += dx
      end
    end
  end

  def part_1
    each_cycle.sum do |x, cycle|
      next 0 unless REL_CYCLES.include?(cycle)
      cycle * x
    end
  end

  def part_2
    each_cycle.map do |x, cycle|
      (x-(cycle - 1) % 40).abs <= 1 ? '█' : ' '
    end.each_slice(40).map(&:join).join("\n")
  end
end

Day10.run if __FILE__ == $0

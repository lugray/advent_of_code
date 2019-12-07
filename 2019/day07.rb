#!/usr/bin/env ruby

require_relative 'day'
require_relative 'intcode'

class Day07 < Day
  def part_1
    max_out = -Float::INFINITY
    ans = ''
    [0,1,2,3,4].permutation.each do |p|
      last_out = 0
      p.each do |phase|
        last_out = Intcode.new(input.split(',').map(&:to_i)).with_inputs(phase, last_out).run.outputs.shift
      end
      if last_out > max_out
        max_out = last_out
        ans = p.join
      end
    end
    max_out
  end

  def part_2
    max_out = -Float::INFINITY
    ans = ''
    [5,6,7,8,9].permutation.each do |p|
      amplifiers = p.map do |phase|
        Intcode.new(input.split(',').map(&:to_i)).with_inputs(phase).run
      end
      last_out = 0
      loop do
        amplifiers.each do |a|
          a.with_inputs(last_out).run(until_output: true)
          if a.outputs.any?
            last_out = a.outputs.shift
          else
            break
          end
        end
        break if amplifiers.any?(&:done?)
      end
      if last_out > max_out
        max_out = last_out
        ans = p.join
      end
    end
    max_out
  end
  
  def input
    super
  end
end

Day07.run if __FILE__ == $0

#!/usr/bin/env ruby

require_relative 'day'
require_relative 'intcode'

class Day23 < Day
  def part_1
    computers = (0...50).map do |n|
      Intcode.new(input.split(',').map(&:to_i)).with_inputs(n)
    end
    loop do
      computers.each do |c|
        c.step
        next unless c.outputs.length >= 3
        dest, x, y = c.outputs.shift(3)
        return y if dest == 255
        computers[dest].with_inputs(x, y)
      rescue Intcode::NoInput
        c.with_inputs(-1).step
      end
    end
  end

  def part_2
    nat = [0, 0]
    last_sent_nat = nil
    idle = Array.new(50, 0)
    computers = (0...50).map do |n|
      Intcode.new(input.split(',').map(&:to_i)).with_inputs(n)
    end
    loop do
      computers.each_with_index do |c, i|
        c.step
        next unless c.outputs.length >= 3
        dest, x, y = c.outputs.shift(3)
        if dest == 255
          nat = [x, y]
        else
          computers[dest].with_inputs(x, y)
          idle[dest] = 0
          idle[i] = 0
        end
      rescue Intcode::NoInput
        c.with_inputs(-1).step
        idle[i] += 1
      end
      if idle.all? { |n| n > 1 }
        return nat.last if last_sent_nat == nat.last
        computers[0].with_inputs(*nat)
        idle[0] = 0
        last_sent_nat = nat.last
      end
    end
  end
end

Day23.run if __FILE__ == $0

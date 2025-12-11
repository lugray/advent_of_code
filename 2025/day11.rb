#!/usr/bin/env ruby

require_relative 'day'

class Day11 < Day
  def initialize
    @paths = {}
    @connections = input_lines.each_with_object({}) do |line, hash|
      from, outs = line.split(': ')
      hash[from] = outs.split(' ')
    end
  end

  def paths(from, to)
    @paths[[from, to]] ||= begin
      return 0 unless @connections.key?(from)
      @connections[from].sum do |next_node|
        next_node == to ? 1 : paths(next_node, to)
      end
    end
  end

  def part_1
    paths('you', 'out')
  end

  def part_2
    paths('svr', 'fft') * paths('fft', 'dac') * paths('dac', 'out') +
      paths('svr', 'dac') * paths('dac', 'fft') * paths('fft', 'out')
  end
end

Day11.run if __FILE__ == $0

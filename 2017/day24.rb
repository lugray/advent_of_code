#!/usr/bin/env ruby

require_relative 'day'

class Day24 < Day
  def initialize
    @components = input_lines do |line|
      line.split('/').map(&:to_i)
    end
  end

  def each_bridge(from = 0, components = @components, &block)
    return enum_for(:each_bridge, from, components) unless block_given?
    components.select { |c| c.include?(from) }.each do |c|
      yield [c]
      other = c[0] == from ? c[1] : c[0]
      each_bridge(other, components - [c]) do |bridge|
        yield [c, *bridge]
      end
    end
  end

  def part_1
    each_bridge.max_by { |b| b.flatten.sum }.flatten.sum
  end

  def part_2
    each_bridge.max do |a, b|
      (a.length <=> b.length).nonzero? || a.flatten.sum <=> b.flatten.sum
    end.flatten.sum
  end
end

Day24.run if __FILE__ == $0

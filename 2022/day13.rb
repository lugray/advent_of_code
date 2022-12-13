#!/usr/bin/env ruby

require_relative 'day'
require 'json'

class Array
  alias_method :old_spaceship, :<=>
  def <=>(other) = other.is_a?(Integer) ? self <=> [other] : old_spaceship(other)
end

class Integer
  alias_method :old_spaceship, :<=>
  def <=>(other) = other.is_a?(Array) ? [self] <=> other : old_spaceship(other)
end

class Day13 < Day
  def initialize
    @packets = input_lines { |line| JSON.parse(line) unless line.empty? }.compact
    @dividers = [[[2]], [[6]]]
  end

  def part_1
    @packets.each_slice(2).each_with_index.filter_map { |(left, right), i| i + 1 if (left <=> right) <= 0 }.sum
  end

  def part_2
    (@packets + @dividers).sort.then { |sorted| @dividers.map { |divider| sorted.index(divider) + 1 }.inject(:*) }
  end
end

Day13.run if __FILE__ == $0

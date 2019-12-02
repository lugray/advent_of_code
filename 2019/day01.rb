#!/usr/bin/env ruby

require_relative 'aoc'

class Mod
  def initialize(n)
    @n = n
  end

  def fuel
    @fuel ||= [@n / 3 - 2, 0].max
  end

  def full_fuel
    return 0 if fuel == 0
    fuel + Mod.new(fuel).full_fuel
  end
end

modules = AOC.input.lines.map { |n| Mod.new(n.chomp.to_i) }
puts modules.map(&:fuel).sum
puts modules.map(&:full_fuel).sum

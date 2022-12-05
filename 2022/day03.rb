#!/usr/bin/env ruby

require_relative 'day'
require 'set'

class Day03 < Day
  def initialize
    @rucksacks = input_lines
  end

  def priority(c)
    if (prio = (c.ord - 'a'.ord) + 1) > 0
      prio
    else
      27 + (c.ord - 'A'.ord)
    end
  end

  def common_item(rucksacks)
    rucksacks.map do |rucksack|
      Set.new(rucksack.chars)
    end.reduce(&:&).first
  end

  def part_1
    @rucksacks.sum do |rucksack|
      a = rucksack[0...rucksack.length / 2]
      b = rucksack[rucksack.length / 2...rucksack.length]
      priority(common_item([a, b]))
    end
  end

  def part_2
    @rucksacks.each_slice(3).sum do |rucksacks|
      priority(common_item(rucksacks))
    end
  end
end

Day03.run if __FILE__ == $0

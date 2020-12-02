#!/usr/bin/env ruby

require_relative 'day'

class Day01 < Day
  def initialize
    @entries = input.lines.map(&:to_i)
  end

  def part_1(entries = @entries, target = 2020)
    entries = entries.dup
    while candidate = entries.pop
      matching = target - candidate
      if entries.include?(matching)
        return matching * candidate
      end
    end
  end

  def part_2
    entries = @entries.dup
    while candidate = entries.pop
      if product = part_1(entries, 2020 - candidate)
        return product * candidate
      end
    end
  end
end

Day01.run if __FILE__ == $0

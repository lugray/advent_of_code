#!/usr/bin/env ruby

require_relative 'day'

class Day05 < Day
  def initialize
    fresh, available = input.split("\n\n")
    @fresh = fresh.lines do |l|
      a, b = l.split("-").map(&:to_i)
      (a..b)
    end
    @available = available.ints
  end

  def fresh?(id)
    @fresh.any? { |r| r.include?(id) }
  end

  def part_1
    @available.count(&method(:fresh?)).inspect
  end

  def part_2
    merged = @fresh.sort_by(&:first).each_with_object([]) do |r, merged|
      if merged.any? && merged.last.last+1 >= r.first
        if r.last > merged.last.last
          merged << (merged.pop.first..r.last)
        end
      else
        merged << r
      end
    end
    merged.sum(&:size)
  end
end

Day05.run if __FILE__ == $0

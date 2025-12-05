#!/usr/bin/env ruby

require_relative 'day'
class Range
  def abs
    a,b = [first, last]
    b -= 1 if exclude_end?
    Range.new(*[a,b].sort)
  end

  def +(other)
    RangeSet.new(self, other)
  end

  def <=>(other)
    (first <=> other.first).nonzero? || (other.last <=> last)
  end
end

class RangeSet
  attr_reader :ranges

  def initialize(*ranges)
    @ranges = simplify(ranges.select { |r| r.size > 0 })
  end

  def simplify(ranges)
    ranges.sort!.each_with_object([]) do |r, rs|
      if rs.any? && rs.last.last+1 >= r.first
        if r.last > rs.last.last
          rs << (rs.pop.first..r.last)
        end
      else
        rs << r
      end
    end
  end

  def +(other)
    case other
    when Range
      RangeSet.new(*@ranges, other)
    when RangeSet
      RangeSet.new(*@ranges, *other.ranges)
    end
  end

  def size
    @ranges.sum(&:size)
  end

  def ==(other)
    @ranges == other.ranges
  end
end

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
    RangeSet.new(*@fresh).size
  end
end

Day05.run if __FILE__ == $0

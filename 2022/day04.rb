#!/usr/bin/env ruby

require_relative 'day'

class Day04 < Day
  def initialize
    @pairs = input_lines.map do |line|
      line.split(',').map do |range|
        Range.new(*range.split('-').map(&:to_i))
      end
    end
  end

  def part_1
    @pairs.count do |pair|
      small, big = pair.sort_by(&:size)
      big.cover?(small.begin) && big.cover?(small.end)
    end
  end

  def part_2
    @pairs.count do |pair|
      first, last = pair.sort_by(&:begin)
      first.cover?(last.begin)
    end
  end
end

Day04.run if __FILE__ == $0

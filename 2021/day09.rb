#!/usr/bin/env ruby

require 'set'
require_relative 'day'

class Day09 < Day
  def initialize
    @heights = {}
    input_lines.each_with_index do |l, y|
      l.chomp.chars.each_with_index do |c, x|
        @heights[[x, y]] = c.to_i
      end
    end
  end

  def neighbours(p)
    x, y = p
    [
      [x-1, y],
      [x+1, y],
      [x, y-1],
      [x, y+1],
    ].select { |p| @heights[p] }
  end

  def low_points
    @heights.select do |p, h|
      neighbours(p).map { |p| @heights[p] }.all? { |n_h| n_h > h }
    end
  end

  def part_1
    low_points.sum { |_, n| n + 1 }
  end

  def basin_size(p)
    set = Set.new([p])
    loop do
      size = set.size
      set += set.flat_map { |p| neighbours(p).reject { |p| @heights[p] == 9 } }
      return set.size if set.size == size
    end
  end

  def part_2
    low_points.map(&:first).map { |p| basin_size(p) }.sort.reverse.take(3).inject(&:*)
  end
end

Day09.run if __FILE__ == $0

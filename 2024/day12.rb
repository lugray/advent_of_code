#!/usr/bin/env ruby

require_relative 'day'
require 'set'

class Day12 < Day
  def initialize
    @plots = {}
    input_lines.each_with_index do |line, row|
      line.each_char.each_with_index do |char, col|
        @plots[[row, col]] = char
      end
    end
    @mr = input_lines.size - 1
    @mc = input_lines[0].size - 1
  end

  def neighbors(r, c)
    [[r - 1, c], [r + 1, c], [r, c - 1], [r, c + 1]].select { |r, c| 0 <= r && r <= @mr && 0 <= c && c <= @mc }
  end

  def members(pos, mems = Set.new([pos]))
    neighbors(*pos).each_with_object(mems) do |n|
      next if @plots[n] != @plots[pos] || mems.include?(n)
      members(n, mems << n)
    end
  end

  def price(&block)
    counted = {}
    @plots.sum do |pos, _|
      next 0 if counted[pos]
      members(pos).then do |set|
        set.size * set.sum do |pos|
          counted[pos] = true
          block.call(pos, set)
        end
      end
    end
  end

  def part_1
    price { |pos, set| 4 - neighbors(*pos).count { |n| set.include?(n) } }
  end

  def concave_corner?(set, r, c, dr, dc)
    set.include?([r + dr, c]) && set.include?([r, c + dc]) && !set.include?([r + dr, c + dc])
  end

  def convex_corner?(set, r, c, dr, dc)
    !set.include?([r + dr, c]) && !set.include?([r, c + dc])
  end

  def part_2
    price do |pos, set|
      [-1, 1].repeated_permutation(2).count do |dr, dc|
        concave_corner?(set, *pos, dr, dc) || convex_corner?(set, *pos, dr, dc)
      end
    end
  end
end

Day12.run if __FILE__ == $0

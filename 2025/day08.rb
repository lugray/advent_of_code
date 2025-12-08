#!/usr/bin/env ruby

require_relative 'day'

class Day08 < Day
  def initialize
    @boxes = input_grid(sep:',', &:to_i)
    dist = {}
    @boxes.each_with_index.to_a.combination(2) do |((x1,y1,z1), i), ((x2,y2,z2), j)|
      dist[[i,j]] = Math.sqrt((x2-x1)**2+(y2-y1)**2+(z2-z1)**2)
    end
    @sorted_indices = dist.sort_by { |k, v| v }.map(&:first)
  end

  def merge_in(sets, i, j)
    candidates = sets.select { |s| s.include?(i) || s.include?(j) }
    case candidates.length
    when 2
      sets.delete(candidates.last)
      candidates.first.merge(candidates.last)
    when 1
      candidates.first.merge([i, j])
    when 0
      sets << Set.new([i, j])
    end
  end

  def part_1
    @sorted_indices.first(is_example? ? 10 : 1000).each_with_object([]) do |(i, j), sets|
      merge_in(sets, i, j)
    end.map(&:length).max(3).inject(&:*)
  end

  def part_2
    @sorted_indices.each_with_object([]) do |(i, j), sets|
      merge_in(sets, i, j)
      break [i, j] if sets.size == 1 && sets.first.size == @boxes.size
    end.map { |i| @boxes[i].first }.inject(&:*)
  end
end

Day08.run if __FILE__ == $0

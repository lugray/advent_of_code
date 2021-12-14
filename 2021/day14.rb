#!/usr/bin/env ruby

require_relative 'day'

class Day14 < Day
  def initialize
    polymer, replacements = input.split("\n\n")
    @pair_counts = " #{polymer} ".each_char.each_cons(2).each_with_object(Hash.new { 0 }) do |(a, b), h|
      h[[a, b]] += 1
    end
    @replacements = replacements.each_line.each_with_object({}) do |l, h|
      pair, mid = l.chomp.split(' -> ')
      h[pair.chars] = mid
    end
  end

  def step(pair_counts)
    pair_counts.each_with_object(Hash.new { 0 }) do |(pair, count), h|
      if middle = @replacements[pair]
        h[[pair.first, middle]] += count
        h[[middle, pair.last]] += count
      else
        h[pair] += count
      end
    end
  end

  def minmax_diff(after:)
    pair_counts = @pair_counts
    after.times { pair_counts = step(pair_counts) }
    pair_counts.each_with_object(Hash.new { 0 }) do |(pair, count), h|
      h[pair.first] += count
      h[pair.last] += count
    end.transform_values { |v| v / 2 }.reject { |k, _| k == ' ' }.map(&:last).minmax.reverse.inject(&:-)
  end

  def part_1
    minmax_diff(after: 10)
  end

  def part_2
    minmax_diff(after: 40)
  end
end

Day14.run if __FILE__ == $0

#!/usr/bin/env ruby

require_relative 'day'
require 'set'

class Day24 < Day
  def initialize
    @weights = input.each_line.map(&:to_i)
  end

  def groups(set, target)
    return enum_for(:groups, set, target) unless block_given?
    if target == 0
      yield Set.new
      return
    end
    set.each_with_index do |elem, i|
      next if elem > target
      groups(set[i+1..], target - elem).each do |inner_set|
        yield Set.new([elem]) + inner_set
      end
    end
  end

  def qe(g)
    g.inject(&:*)
  end

  def part_1
    qe(
      groups(@weights, @weights.sum / 3).min do |g1, g2|
        (g1.size <=> g2.size).nonzero? || (qe(g1) <=> qe(g2))
      end
    )
  end

  def part_2
    qe(
      groups(@weights, @weights.sum / 4).min do |g1, g2|
        (g1.size <=> g2.size).nonzero? || (qe(g1) <=> qe(g2))
      end
    )
  end
end

Day24.run if __FILE__ == $0

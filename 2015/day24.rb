#!/usr/bin/env ruby

require_relative 'day'
require 'set'

class Day24 < Day
  def initialize
    @weights = input.each_line.map(&:to_i)
  end

  def groups(set, target, max_size)
    return enum_for(:groups, set, target, max_size) unless block_given?
    if target == 0
      yield Set.new
      return
    end
    return if max_size == 0
    set.each_with_index do |elem, i|
      next if elem > target
      groups(set[i+1..], target - elem, max_size - 1).each do |inner_set|
        yield Set.new([elem]) + inner_set
      end
    end
  end

  def best_qe(set, n)
    qe(
      groups(set, set.sum / n, set.size / n).min do |g1, g2|
        (g1.size <=> g2.size).nonzero? || (qe(g1) <=> qe(g2))
      end
    )
  end

  def qe(g)
    g.inject(&:*)
  end

  def part_1
    best_qe(@weights, 3)
  end

  def part_2
    best_qe(@weights, 4)
  end
end

Day24.run if __FILE__ == $0

#!/usr/bin/env ruby

require_relative 'day'

class Day05 < Day
  def initialize
    crates, instructions = input.split("\n\n").map { _1.lines(chomp: true) }
    indices = crates.pop.chars.each_with_index.filter_map { |c, i| i unless c == ' ' }
    @stacks = crates.map do |line|
      line.chars.values_at(*indices)
    end.transpose.map { |stack| stack.reject { _1 == ' ' }.reverse }
    @stacks.unshift(['']) # 1-indexed
    @instructions = instructions.map do |line|
      line.match(/move (\d+) from (\d+) to (\d+)/).captures.map(&:to_i)
    end
  end

  def manipulate_stacks
    stacks = @stacks.map(&:dup)
    @instructions.each do |n, from, to|
      yield(stacks, n, from, to)
    end
    stacks.map(&:last).join
  end

  def part_1
    manipulate_stacks do |stacks, n, from, to|
      n.times { stacks[to].push(stacks[from].pop) }
    end
  end

  def part_2
    manipulate_stacks do |stacks, n, from, to|
      stacks[to].push(*stacks[from].pop(n))
    end
  end
end

Day05.run if __FILE__ == $0

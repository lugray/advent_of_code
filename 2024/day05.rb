#!/usr/bin/env ruby

require_relative 'day'

class Day05 < Day
  def initialize
    rules, lists = input.split("\n\n")
    @rules = rules.each_line(chomp: true).each_with_object({}) do |line, hash|
      key, value = line.split('|')
      hash[[key.to_i, value.to_i]] = true
    end
    @lists = lists.each_line(chomp: true).map { |line| line.split(',').map(&:to_i) }
  end

  def ordered_pair?(a, b)
    !@rules[[b,a]]
  end

  def ordered_list?(list)
    list.each_with_index.all? do |a, i|
      list.drop(i+1).all? { |b| ordered_pair?(a, b) }
    end
  end

  def part_1
    @lists.select { |list| ordered_list?(list) }.sum do |list|
      list[list.size/2]
    end
  end

  def sort_fn(a, b)
    if ordered_pair?(a, b)
      -1
    elsif ordered_pair?(b, a)
      1
    else
      0
    end
  end

  def part_2
    lists = @lists.reject { |list| ordered_list?(list) }.sum do |list|
      list.sort { |a, b| sort_fn(a, b) }[list.size/2]
    end
  end
end

Day05.run if __FILE__ == $0

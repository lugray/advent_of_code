#!/usr/bin/env ruby

require_relative 'day'

class Rule
  attr_reader :main_bag

  def initialize(text)
    @main_bag = text.match(/^(\w+ \w+) bags contain/)[1]
    @contained = text.scan(/ (\d+) (\w+ \w+) bags?[,.]/).map { |n, bag| [n.to_i, bag] }
  end

  def contain_count(rules)
    @contain_count ||= @contained.sum do |n, bag|
      n * (1 + rules[bag].contain_count(rules))
    end
  end

  def contains?(bag)
    @contained.any? do |_n, b|
      bag == b
    end
  end
end

class Day07 < Day
  def initialize
    @rules = input.each_line.map do |l|
      r = Rule.new(l)
      [r.main_bag, r]
    end.to_h
  end

  def part_1
    bags = []
    new_bags = ['shiny gold']
    while new_bags.any? do
      bags += new_bags
      new_bags = new_bags.flat_map do |new_bag|
        @rules.values.select { |r| r.contains?(new_bag) }.map(&:main_bag)
      end.uniq
      new_bags -= bags
    end
    bags.count - 1
  end

  def part_2
    @rules['shiny gold'].contain_count(@rules)
  end
end

Day07.run if __FILE__ == $0

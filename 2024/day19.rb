#!/usr/bin/env ruby

require_relative 'day'

class Day19 < Day
  def initialize
    available, desired = input_paragraphs
    @desired = desired.lines
    @available = available.chomp.split(", ")
    @count = {}
  end

  def count(pattern)
    @count[pattern] ||= @available.sum do |option|
      next 0 unless pattern.start_with?(option)
      next 1 if pattern == option
      count(pattern[option.size..])
    end
  end

  def part_1
    @desired.count { |pattern| count(pattern) > 0 }
  end

  def part_2
    @desired.sum { |pattern| count(pattern) }
  end
end

Day19.run if __FILE__ == $0

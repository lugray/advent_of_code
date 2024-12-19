#!/usr/bin/env ruby

require_relative 'day'

class Day19 < Day
  def initialize
    available, desired = input_paragraphs
    @desired = desired.lines
    @possible = {}
    @available = available.chomp.split(", ")
    @available.each { |pattern| @possible[pattern] = true }
    @count = {}
  end

  def possible?(pattern)
    return @possible[pattern] if @possible.key?(pattern)
    @possible[pattern] = (1...pattern.size).any? { |i| @possible[pattern[0...i]] && possible?(pattern[i..]) }
  end

  def count(pattern)
    @count[pattern] ||= @available.sum do |option|
      next 0 unless pattern.start_with?(option)
      next 1 if pattern == option
      count(pattern[option.size..])
    end
  end

  def part_1
    @desired.count do |pattern|
      possible?(pattern)
    end
  end

  def part_2
    @desired.sum do |pattern|
      count(pattern)
    end
  end
end

Day19.run if __FILE__ == $0

#!/usr/bin/env ruby

require_relative 'day'

class Parser
  def initialize(input, size = 25)
    @size = size
    @input = input.each_line.map(&:to_i)
  end

  def first_invalid
    @first_invalid ||= compute_first_invalid
  end

  def encryption_weakness
    @input.each_with_object([]) do |val, contiguous|
      contiguous.push(val)
      while contiguous.sum > first_invalid
        contiguous.shift
      end
      return contiguous.min + contiguous.max if contiguous.sum == first_invalid
    end
  end

  private

  def compute_first_invalid
    @input.each_with_object([]) do |val, history|
      return val if history.size == @size && !has_addends?(history, val)
      history.push(val)
      history.shift if history.size > @size
    end
  end

  def has_addends?(values, target)
    values.any? do |n|
      (values - [n]).include?(target - n)
    end
  end
end

class Day09 < Day
  def initialize
    @parser = Parser.new(input)
  end

  def part_1
    @parser.first_invalid
  end

  def part_2
    @parser.encryption_weakness
  end
end

Day09.run if __FILE__ == $0

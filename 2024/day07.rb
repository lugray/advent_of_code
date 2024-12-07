#!/usr/bin/env ruby

require_relative 'day'

class Day07 < Day
  def initialize
    @equations = input_grid(&:to_i)
  end

  def possible_with_mult?(result, values, concat: false)
    result % values.last == 0 && possible?(result / values.last, values[0..-2], concat:)
  end

  def possible_with_add?(result, values, concat: false)
    result > values.last && possible?(result - values.last, values[0..-2], concat:)
  end

  def possible_with_concat?(result, values, concat: false)
    concat && result.to_s.end_with?(values.last.to_s) && possible?(result / 10**(values.last.to_s.size), values[0..-2], concat:)
  end

  def possible?(result, values, concat: false)
    return values.first == result if values.size == 1
    possible_with_mult?(result, values, concat:) || possible_with_concat?(result, values, concat:) || possible_with_add?(result, values, concat:)
  end

  def sum_possible(concat: false)
    @equations.sum { |result, *values| possible?(result, values, concat:) ? result : 0 }
  end

  def part_1
    sum_possible
  end

  def part_2
    sum_possible(concat: true)
  end
end

Day07.run if __FILE__ == $0

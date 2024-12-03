#!/usr/bin/env ruby

require_relative 'day'

class Day03 < Day
  def initialize
    @instructions = input
  end

  def number_at(str, i, j)
    return nil if j - i < 0
    return nil if j - i > 2
    return nil if str[i..j].each_char.any? { |c| c < '0' || c > '9' }
    str[i..j].to_i
  end

  def mul_at(str, i)
    j = str.index(',', i)
    k = str.index(')', j)
    a = number_at(str, i + 4, j - 1)
    b = number_at(str, j + 1, k - 1)
    a && b ? a * b : 0
  end

  def mulsum(str)
    return 0 unless str && i = str.index('mul(')
    mul_at(str, i) + mulsum(str[i + 4..])
  end

  def part_1
    mulsum(@instructions)
  end

  def part_2
    ("do()" + @instructions).split("don't()").sum do |str|
      mulsum(str.split("do()", 2)[1])
    end
  end
end

Day03.run if __FILE__ == $0

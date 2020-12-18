#!/usr/bin/env ruby

require_relative 'day'

class Integer
  alias_method :original_m, :*
  alias_method :original_p, :+

  def *(other)
   original_p(other)
  end

  def +(other)
   original_m(other)
  end

  def -(other)
    original_p(other)
  end
end

class Day18 < Day
  def initialize
    @calculations = input.each_line(chomp: true)
  end

  def part_1
    @calculations.sum { |c| eval(c.gsub(/[*+]/, { '*' => '+', '+' => '-' })) }
  end

  def part_2
    @calculations.sum { |c| eval(c.gsub(/[*+]/, { '*' => '+', '+' => '*' })) }
  end
end

Day18.run if __FILE__ == $0

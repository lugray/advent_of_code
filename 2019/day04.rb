#!/usr/bin/env ruby

require_relative 'aoc'

class Integer
  def monotonic_increasing?
    digits.each_cons(2).all? { |a, b| a >= b }
  end

  def has_double?
    digits.each_cons(2).any? { |a, b| a == b }
  end

  def has_strict_double?
    digits.push(nil).unshift(nil).each_cons(4).any? do |a, b, c, d|
      a != b && b == c && c != d
    end
  end
end

range = Range.new(*AOC.input.split('-').map(&:to_i))
puts range.count { |n| n.monotonic_increasing? && n.has_double? }
puts range.count { |n| n.monotonic_increasing? && n.has_strict_double? }

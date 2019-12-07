#!/usr/bin/env ruby

require_relative 'day'
require 'prime'

class Day20 < Day
  def factors_of(number)
    primes, powers = number.prime_division.transpose
    exponents = powers.map{|i| (0..i).to_a}
    exponents.shift.product(*exponents).map do |powers|
      primes.zip(powers).map{|prime, power| prime ** power}.inject(:*)
    end.sort
  end

  def presents_to(n)
    factors_of(n).sum * 10
  end

  def lazy_presents_to(n)
    factors_of(n).select { |f| n / f <= 50 }.sum * 11
  end

  def part_1
    min_presents = input.to_i
    (2..Float::INFINITY).find { |n| presents_to(n) >= min_presents }
  end

  def part_2
    min_presents = input.to_i
    (2..Float::INFINITY).find { |n| lazy_presents_to(n) >= min_presents }
  end
end

Day20.run if __FILE__ == $0

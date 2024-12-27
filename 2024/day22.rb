#!/usr/bin/env ruby

require_relative 'day'

class Day22 < Day
  PRUNE = 16777216
  PRICES = 2001

  def initialize = @starts = input_lines(&:to_i)
  def mix(n, v) = (n ^ v) % PRUNE
  def next_secret(n) = mix(n, n * 64).then { |n| mix(n, n / 32) }.then { |n| mix(n, n * 2048) }

  def secret_sequence(n)
    return enum_for(__method__, n) unless block_given?
    PRICES.times { yield n; n = next_secret(n) }
  end

  def price_sequence(n)
    secret_sequence(n).lazy.map { |n| n % 10 }
  end

  def part_1
    @starts.sum { |n| secret_sequence(n).reduce { |_, n| n } }
  end

  def part_2
    @starts.each_with_object(Hash.new(0)) do |n, count|
      found = {}
      price_sequence(n).each_cons(5) do |sub_seq|
        diffs = sub_seq.each_cons(2).map {|a, b| b - a }
        next if found[diffs]
        found[diffs] = true
        count[diffs] += sub_seq.last
      end
    end.values.max
  end
end

Day22.run if __FILE__ == $0

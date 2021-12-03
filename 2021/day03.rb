#!/usr/bin/env ruby

require_relative 'day'

class Day03 < Day
  def initialize
    @diagnostic = input_lines
  end

  def sorted(diagnostic = @diagnostic)
    columns = diagnostic.map { |l| l.each_char.to_a }.transpose
    columns.map do |col|
      col.tally.sort do |(k1, v1), (k2, v2)|
        (v1 <=> v2).nonzero? || (k1.to_i <=> k2.to_i)
      end.map { |k, v| k }
    end
  end

  def part_1
    gamma = sorted.map(&:last).join.to_i(2)
    epsilon = sorted.map(&:first).join.to_i(2)
    gamma * epsilon
  end

  def part_2
    oxygen_generator_rating * co2_scrubber_rating
  end

  def filter_list
    list = @diagnostic.dup
    (0..).each do |i|
      target = yield sorted(list)[i]
      list.select! { |l| l[i] == target }
      return list.first.to_i(2) if list.length == 1
    end
  end

  def oxygen_generator_rating
    filter_list(&:last)
  end

  def co2_scrubber_rating
    filter_list(&:first)
  end
end

Day03.run if __FILE__ == $0

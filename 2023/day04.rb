#!/usr/bin/env ruby

require_relative 'day'

class Day04 < Day
  def initialize
    @cards = input_lines.each_with_object({}) do |line, cards|
      id, nums = line.split(': ')
      cards[id.split(' ').last.to_i] = nums.split(' | ').map { |set| set.split(' ').map(&:to_i) }.inject(:&).size
    end
  end

  def part_1
    @cards.sum { |_, wins| wins == 0 ? 0 : 2**(wins-1) }
  end

  def part_2
    @cards.each_with_object(Hash.new(0)) do |(id, wins), card_counts|
      card_counts[id] += 1
      wins.times { |n| card_counts[id+n+1] += card_counts[id] }
    end.values.sum
  end
end

Day04.run if __FILE__ == $0

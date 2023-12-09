#!/usr/bin/env ruby

require_relative 'day'

class Day09 < Day
  def initialize
    @sequences = input_lines(&:ints)
  end

  def next_in(sequence)
    return 0 if sequence.all?(0)
    sequence.last + next_in(sequence.each_cons(2).map { |a, b| b - a })
  end

  def prev_in(sequence)
    return 0 if sequence.all?(0)
    sequence.first - prev_in(sequence.each_cons(2).map { |a, b| b - a })
  end

  def part_1
    @sequences.sum { |s| next_in(s) }
  end

  def part_2
    @sequences.sum { |s| prev_in(s) }
  end
end

Day09.run if __FILE__ == $0

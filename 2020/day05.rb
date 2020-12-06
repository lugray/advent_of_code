#!/usr/bin/env ruby

require_relative 'day'

class Seat
  def initialize(spec)
    @spec = spec.chomp
  end

  def id
    @spec.each_char.map { |c| (c == 'R' || c == 'B') ? '1' : '0' }.join.to_i(2)
  end
end

class Day05 < Day
  def initialize
    @seats = input.each_line.map { |spec| Seat.new(spec) }
  end

  def part_1
    @seats.map(&:id).max
  end

  def part_2
    @seats.map(&:id).sort.chunk_while { |i, j| i + 1 == j }.first.last + 1
  end
end

Day05.run if __FILE__ == $0

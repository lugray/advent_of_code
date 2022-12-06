#!/usr/bin/env ruby

require_relative 'day'

class Day06 < Day
  def initialize
    @data = input.chars
  end

  def marker_pos(length)
    @data.each_cons(length).find_index do |maybe_marker|
      maybe_marker.uniq.size == length
    end + length
  end

  def part_1
    marker_pos(4)
  end

  def part_2
    marker_pos(14)
  end
end

Day06.run if __FILE__ == $0

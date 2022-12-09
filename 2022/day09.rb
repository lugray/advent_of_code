#!/usr/bin/env ruby

require_relative 'day'
require 'matrix'
require 'set'

class Day09 < Day
  DIRECTIONS = { 'U' => Vector[0, -1], 'D' => Vector[0, 1], 'L' => Vector[-1, 0], 'R' => Vector[1, 0] }

  def initialize
    @motions = input_grid
  end

  def simulate(knots)
    @motions.each_with_object(Set.new) do |(dir, dist), tail_visits|
      dist.times do
        knots[0] += DIRECTIONS[dir]
        (1...knots.size).each do |i|
          offset = knots[i-1] - knots[i]
          knots[i] += offset.map { |c| c <=> 0 } if offset.magnitude > 1.9
        end
        tail_visits << knots.last
      end
    end.size
  end

  def part_1
    simulate(Array.new(2) { Vector[0, 0] })
  end

  def part_2
    simulate(Array.new(10) { Vector[0, 0] })
  end
end

Day09.run if __FILE__ == $0

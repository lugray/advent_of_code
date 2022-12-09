#!/usr/bin/env ruby

require_relative 'day'
require 'matrix'
require 'set'

class Day09 < Day
  DIRECTIONS = { 'U' => Vector[0, -1], 'D' => Vector[0, 1], 'L' => Vector[-1, 0], 'R' => Vector[1, 0] }
  ZERO = Vector[0, 0]

  def initialize
    @motions = input_grid
  end

  def simulate(knots)
    tail_visits = Set.new
    @motions.each do |dir, dist|
      dist.times do
        knots[0] += DIRECTIONS[dir]
        (1...knots.size).each do |i|
          offset = knots[i-1] - knots[i]
          mag = offset.magnitude # 0, 1, sqrt(2) =~ 1.4, 2, or sqrt(5) =~ 2.2
          knots[i] += if mag < 1.5 # Tail is touching head
            ZERO
          elsif mag < 2.1 # =2 Tail is separated from head by 1 row or column
            offset / 2
          else # =sqrt(5) Tail is separated from head on a skewed diagonal
            offset.map {|c| c / c.abs }
          end
        end
        tail_visits << knots.last
      end
    end
    tail_visits.size
  end

  def part_1
    simulate(Array.new(2) { ZERO })
  end

  def part_2
    simulate(Array.new(10) { ZERO })
  end
end

Day09.run if __FILE__ == $0

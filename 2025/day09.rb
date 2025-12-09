#!/usr/bin/env ruby

require_relative 'day'

class Day09 < Day
  def initialize
    @coords = input_lines(&:ints)
  end

  def part_1
    @coords.combination(2).map do |(x1, y1), (x2, y2)|
      ((x2-x1).abs+1) * ((y2-y1).abs+1)
    end.max
  end

  def intersect?(ex1, ey1, ex2, ey2, x1, y1, x2, y2)
    x1 < ex2 && x2 > ex1 && y1 < ey2 && y2 > ey1
  end

  def part_2
    edges = (@coords + [@coords.first]).each_cons(2).map do |(x1, y1), (x2, y2)|
      x1, x2 = [x1, x2].sort
      y1, y2 = [y1, y2].sort
      [x1, y1, x2, y2]
    end.sort_by do |x1, y1, x2, y2|
      -((x2-x1).abs+1) * ((y2-y1).abs+1)
    end

    @coords.combination(2).map do |(x1, y1), (x2, y2)|
      x1, x2 = [x1, x2].sort
      y1, y2 = [y1, y2].sort
      next 0 if edges.any? { |ex1, ey1, ex2, ey2| intersect?(ex1, ey1, ex2, ey2, x1, y1, x2, y2) }
      ((x2-x1).abs+1) * ((y2-y1).abs+1)
    end.max
  end
end

Day09.run if __FILE__ == $0

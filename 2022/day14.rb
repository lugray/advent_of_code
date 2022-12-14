#!/usr/bin/env ruby

require_relative 'day'
require 'matrix'

class Day14 < Day
  DROPS = [Vector[0, 1], Vector[-1, 1], Vector[1, 1]]

  def initialize
    @map = {}
    input.each_line(chomp: true) do |l|
      l.split(' -> ').map do |point|
        point.split(',').map(&:to_i)
      end.each_cons(2).each do |(x1, y1), (x2, y2)|
        x1, x2 = [x1, x2].sort
        y1, y2 = [y1, y2].sort
        (x1..x2).each do |x|
          (y1..y2).each do |y|
            @map[Vector[x, y]] = :rock
          end
        end
      end
    end
    @max_depth = @map.keys.map { |v| v[1] }.max
  end

  def drop_sand(map = @map.dup)
    pos = Vector[500, 0]
    while pos[1] <= @max_depth
      if new_pos = DROPS.map { |d| pos + d }.find { |p| !map[p] }
        pos = new_pos
      else
        map[pos] = :sand
        pos = Vector[500, 0]
      end
    end
    map
  end

  def with_floor(map = @map.dup)
    (500-@max_depth-2..500+@max_depth+2).each { |x| map[Vector[x, @max_depth+2]] = :rock }
    map
  end

  def sand_fill(map = with_floor, pos = Vector[500, 0])
    return map if map[pos]
    map[pos] = :sand
    DROPS.each do |d|
      sand_fill(map, pos + d)
    end
    map
  end

  def part_1
    drop_sand.count { |_, v| v == :sand }
  end

  def part_2
    sand_fill.count { |_, v| v == :sand }
  end
end

Day14.run if __FILE__ == $0

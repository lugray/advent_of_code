#!/usr/bin/env ruby

require_relative 'day'

class Asteroid
  attr_reader :r, :c
  def initialize(r, c)
    @r = r
    @c = c
  end

  def ==(other)
    r == other.r && c == other.c
  end

  def angle_to(other)
    ((-Math.atan2(r - other.r, c - other.c) + Math::PI / 2) % (2 * Math::PI))
  end

  def taxi_dist(other)
    (r - other.r).abs + (c - other.c).abs
  end

  def to_s
    "#{c},#{r}"
  end

  def pos
    c * 100 + r
  end
end

class Day10 < Day
  def initialize
    @asteroids = []
    input.lines.each_with_index do |line, row|
      line.chomp.each_char.each_with_index do |char, col|
        if char == '#'
          @asteroids << Asteroid.new(row, col)
        end
      end
    end
  end

  def best_asteroid
    counts = @asteroids.map do |a|
      @asteroids.map { |a2| a.angle_to(a2) }.uniq.count
    end
    @asteroids[counts.each_with_index.max.last]
  end

  def part_1
    # best_asteroid.last
    @asteroids.map do |a|
      @asteroids.map { |a2| a.angle_to(a2) }.uniq.count
    end.max
  end

  def part_2
    a = best_asteroid
    (@asteroids - [a]).sort_by do |a2|
      10 * a.taxi_dist(a2) + a.angle_to(a2)
    end.take(10)
  end

  def input
    '.#..##.###...#######
##.############..##.
.#.######.########.#
.###.#######.####.#.
#####.##.#.##.###.##
..#####..#.#########
####################
#.####....###.#.#.##
##.#################
#####.##.###..####..
..######..##.#######
####.##.####...##..#
.#####..#.######.###
##...#.##########...
#.##########.#######
.####.#.###.###.#.##
....##.##.###..#####
.#.#.###########.###
#.#.#.#####.####.###
###.##.####.##.#..##'
  end
end

Day10.run if __FILE__ == $0

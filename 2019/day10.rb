#!/usr/bin/env ruby

require_relative 'day'

class Intline
  include Enumerable

  def initialize(x1, dx, y1, dy, s)
    @x1 = x1
    @dx = dx
    @y1 = y1
    @dy = dy
    @s = s
  end

  def each
    return enum_for(:each) unless block_given?
    x = @x1
    y = @y1
    @s.times do
      yield x, y
      x += @dx
      y += @dy
    end
  end
end

class Day10 < Day
  def intermediary_count(asteroids, row1, col1, row2, col2)
    dr = row2 - row1
    dc = col2 - col1
    return Float::INFINITY if dr == 0 && dc == 0
    gcd = dr.gcd(dc)
    sr = dr / gcd
    sc = dc / gcd
    Intline.new(row1 + sr, sr, col1 + sc, sc, gcd - 1).count { |r, c| !asteroids[[r, c]].nil? }
  end

  def visible?(asteroids, row1, col1, row2, col2)
    intermediary_count(asteroids, row1, col1, row2, col2) == 0
  end

  def asteroids_hash
    asteroids = {}
    input.lines.each_with_index do |line, row|
      line.chomp.each_char.each_with_index do |char, col|
        if char == '#'
          asteroids[[row, col]] = 0
        end
      end
    end
    asteroids
  end

  def best_asteroid
    @best_asteroid ||= begin
      asteroids = asteroids_hash
      asteroids.keys.each do |row1, col1|
        asteroids.keys.each do |row2, col2|
          asteroids[[row1, col1]] += 1 if visible?(asteroids, row1, col1, row2, col2)
        end
      end
      asteroids.max_by { |k, v| v }
    end
  end

  def part_1
    best_asteroid.last
  end

  def sorter(asteroids, row1, col1, row2, col2)
    intermediary_count(asteroids, row1, col1, row2, col2) * 10 + ((-Math.atan2(row1 - row2, col2 - col1) + Math::PI / 2) % (2 * Math::PI))
  end

  def part_2
    row1, col1 = best_asteroid.first
    asteroids = asteroids_hash
    row, col = asteroids.keys.sort_by do |row2, col2|
      sorter(asteroids, row1, col1, row2, col2)
    end[200 - 1]
    col * 100 + row
  end
end

Day10.run if __FILE__ == $0

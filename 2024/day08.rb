#!/usr/bin/env ruby

require_relative 'day'

class Day08 < Day
  def initialize
    @antennas = {}
    @min_r = @min_c = 0
    @max_r = input_lines.size - 1
    @max_c = input_lines[0].size - 1
    input_lines.each_with_index do |line, r|
      line.each_char.with_index do |char, c|
        next if char == '.'
        @antennas[char] ||= []
        @antennas[char] << [r, c]
      end
    end
  end

  def in_bounds?(r, c) = r.between?(@min_r, @max_r) && c.between?(@min_c, @max_c)

  def add_antinode(r, c, antinodes)
    return unless in_bounds?(r, c)
    antinodes[[r, c]] = true
  end

  def part_1
    antinodes = {}
    @antennas.each do |char, coords|
      coords.combination(2).each do |(r1, c1), (r2, c2)|
        delta_r = r2 - r1
        delta_c = c2 - c1
        add_antinode(r2 + delta_r, c2 + delta_c, antinodes)
        add_antinode(r1 - delta_r, c1 - delta_c, antinodes)
      end
    end
    antinodes.size
  end

  def part_2
    antinodes = {}
    @antennas.each do |char, coords|
      coords.combination(2).each do |(r1, c1), (r2, c2)|
        delta_r = r2 - r1
        delta_c = c2 - c1
        gcd = delta_r.gcd(delta_c)
        delta_r /= gcd
        delta_c /= gcd
        min = -[(r1-@min_r) / delta_r, (c1-@min_c) / delta_c].max - 1
        max = [(@max_r-r2) / delta_r, (@max_c-c2) / delta_c].max + 1
        (min..max).each do |i|
          add_antinode(r2 + delta_r * i, c2 + delta_c * i, antinodes)
        end
      end
    end
    antinodes.size
  end
end

Day08.run if __FILE__ == $0

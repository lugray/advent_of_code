#!/usr/bin/env ruby

require_relative 'day'

class Day20 < Day
  def initialize
    @start_map = {}
    @end_map = {}
    input.each_line(chomp: true).each_with_index do |line, row|
      line.each_char.with_index do |cell, col|
        next if cell == '#'
        @start_map[[row, col]] = Float::INFINITY
        @end_map[[row, col]] = Float::INFINITY
        if cell == 'S'
          @start = [row, col]
          @start_map[[row, col]] = 0
        end
        if cell == 'E'
          @end = [row, col]
          @end_map[[row, col]] = 0
        end
      end
    end
    dijkstra(@start_map, Set.new([@start]))
    dijkstra(@end_map, Set.new([@end]))
  end

  def dijkstra(map, candidates)
    loop do
      r, c = candidates.min_by { |r, c| map[[r, c]] }
      break unless r
      candidates.delete([r, c])
      neighbors(r, c).each do |nr, nc|
        next unless map[[nr, nc]]
        if map[[nr, nc]] > map[[r, c]] + 1
          map[[nr, nc]] = map[[r, c]] + 1
          candidates << [nr, nc]
        end
      end
    end
  end

  def neighbors(row, col)
    [[row, col + 1], [row + 1, col], [row, col - 1], [row - 1, col]]
  end

  def path_in_radius(row, col, radius)
    (-radius..radius).flat_map do |dr|
      dcmax = radius - dr.abs
      (-dcmax..dcmax).map { |dc| [row + dr, col + dc] }
    end.select { |r, c| @end_map[[r, c]] }
  end

  def count(duration, savings)
    full = @start_map[@end]
    @start_map.sum do |(r, c), d|
      path_in_radius(r, c, duration).count { |r2, c2| @end_map[[r2, c2]] + d + (r2 - r).abs + (c2 - c).abs <= full - savings }
    end
  end

  def part_1
    count(2, 100)
  end

  def part_2
    count(20, 100)
  end
end

Day20.run if __FILE__ == $0

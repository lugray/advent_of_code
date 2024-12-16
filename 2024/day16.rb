#!/usr/bin/env ruby

require_relative 'day'
require 'set'

class Day16 < Day
  EAST = 0
  SOUTH = 1
  WEST = 2
  NORTH = 3
  DIRS = [EAST, SOUTH, WEST, NORTH]

  def initialize
    @map = {}
    input.each_line(chomp: true).each_with_index do |line, row|
      line.each_char.with_index do |cell, col|
        next if cell == '#'
        DIRS.each { |dir| @map[[row, col, dir]] = Float::INFINITY }
        if cell == 'S'
          @map[[row, col, EAST]] = 0
          @start = [row, col, EAST]
        end
        @end = [row, col] if cell == 'E'
      end
    end
    candidates = Set.new([@start])
    @prev = Hash.new { |h, k| h[k] = Set.new }
    loop do
      r, c, d = candidates.min_by { |r, c, d| @map[[r, c, d]] }
      break if [r, c] == @end
      candidates.delete([r, c, d])
      neighbors(r, c, d).each do |nr, nc, nd|
        next unless @map[[nr, nc, nd]]
        cost = nd == d ? 1 : 1000
        if @map[[nr, nc, nd]] > @map[[r, c, d]] + cost
          @map[[nr, nc, nd]] = @map[[r, c, d]] + cost
          @prev[[nr, nc, nd]] << [r, c, d]
          candidates << [nr, nc, nd]
        elsif @map[[nr, nc, nd]] == @map[[r, c, d]] + cost
          @prev[[nr, nc, nd]] << [r, c, d]
        end
      end
    end
  end

  def neighbors(row, col, dir)
    return enum_for(:neighbors, row, col, dir) unless block_given?
    yield [row, col, (dir + 1) % 4]
    yield [row, col, (dir - 1) % 4]
    case dir
    when EAST then yield [row, col + 1, dir]
    when SOUTH then yield [row + 1, col, dir]
    when WEST then yield [row, col - 1, dir]
    when NORTH then yield [row - 1, col, dir]
    end
  end

  def part_1
    DIRS.map { |d| @map[[@end[0], @end[1], d]] }.min
  end

  def best_seats(row, col, dir, seats = Set.new)
    seats << [row, col]
    @prev[[row, col, dir]].each do |r, c, d|
      best_seats(r, c, d, seats)
    end
    seats
  end

  def part_2
    DIRS.each_with_object(Set.new) do |d, seats|
      seats.merge(best_seats(@end[0], @end[1], d))
    end.size
  end
end

Day16.run if __FILE__ == $0

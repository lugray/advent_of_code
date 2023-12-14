#!/usr/bin/env ruby

require_relative 'day'

class Day14 < Day
  def initialize
    @dish = input_grid(sep: '')
  end

  def slide_row(row, reverse: false)
    row.chunk { |c| c == '#' }.each_with_object([]) do |(_, chunk), r|
      r.append(*chunk.sort { |a, b| reverse ? b <=> a : a <=> b })
    end
  end

  def north(dish) = dish.transpose.map { |row| slide_row(row, reverse: true) }.transpose
  def west(dish) = dish.map { |row| slide_row(row, reverse: true) }
  def south(dish) = dish.transpose.map { |row| slide_row(row) }.transpose
  def east(dish) = dish.map { |row| slide_row(row) }
  def cycle(dish) = east(south(west(north(dish))))

  def north_load(dish)
    dish.transpose.sum do |row|
      row.each_with_index.sum { |c, i| c == 'O' ? row.length - i : 0 }
    end
  end

  def part_1
    north_load(north(@dish))
  end

  def part_2
    dish = @dish
    seen = {}
    i = (1..).find do |i|
      dish = cycle(dish)
      seen.key?(dish).tap { seen[dish] ||= i }
    end
    cycle_length = i - seen[dish]
    remaining = (1_000_000_000 - i) % cycle_length

    dish = seen.key(seen[dish]+remaining)
    north_load(dish)
  end
end

Day14.run if __FILE__ == $0

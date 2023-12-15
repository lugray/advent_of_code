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

  def each_cycle(dish)
    return enum_for(:each_cycle, dish) unless block_given?
    loop { yield dish = cycle(dish) }
  end

  def part_2
    dish = each_cycle(@dish).cyclic_at(1_000_000_000 - 1)
    north_load(dish)
  end
end

Day14.run if __FILE__ == $0

#!/usr/bin/env ruby

require_relative 'day'
require 'matrix'

class Day06 < Day
  def initialize
    fish_arr = input_numbers.each_with_object(Array.new(9) { 0 }) do |timer, arr|
      arr[timer] += 1
    end
    @fish = Vector[*fish_arr].to_matrix
    # ┏                   ┓
    # ┃ 0 1 0 0 0 0 0 0 0 ┃
    # ┃ 0 0 1 0 0 0 0 0 0 ┃
    # ┃ 0 0 0 1 0 0 0 0 0 ┃
    # ┃ 0 0 0 0 1 0 0 0 0 ┃
    # ┃ 0 0 0 0 0 1 0 0 0 ┃
    # ┃ 0 0 0 0 0 0 1 0 0 ┃
    # ┃ 1 0 0 0 0 0 0 1 0 ┃
    # ┃ 0 0 0 0 0 0 0 0 1 ┃
    # ┃ 1 0 0 0 0 0 0 0 0 ┃
    # ┗                   ┛
    @matrix = Matrix[*Matrix.identity(9).to_a.rotate]
    @matrix[6, 0] = 1
  end

  def count_after(days)
    (@matrix**days * @fish).to_a.flatten.sum
  end

  def part_1
    count_after(80)
  end

  def part_2
    count_after(256)
  end
end

Day06.run if __FILE__ == $0

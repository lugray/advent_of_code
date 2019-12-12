#!/usr/bin/env ruby

require_relative 'day'
require_relative 'intcode'
require 'matrix'

class Day11 < Day
  ROTATIONS = [
    Matrix[[0, -1], [1, 0]], # Counterclockwise
    Matrix[[0, 1], [-1, 0]], # CLockwise
  ]

  def initialize
    @colors = Hash.new(0)
    @location = Vector[0, 0]
    @direction = Vector[0,1]
    @robot = Intcode.new(input.split(',').map(&:to_i))
  end

  def part_1
    paint
    @colors.count
  end

  def part_2
    initialize
    @colors[@location] = 1
    paint
    display
  end

  private

  def paint
    loop do
      @robot.with_inputs(@colors[@location]).run
      break if @robot.done?
      @colors[@location] = @robot.outputs.shift
      @direction = ROTATIONS[@robot.outputs.shift] * @direction
      @location += @direction
    end
  end

  def display
    x_range = Range.new(*@colors.keys.map { |v| v[0] }.minmax)
    y_range = Range.new(*@colors.keys.map { |v| v[1] }.minmax)
    y_range.reverse_each.map do |y|
      x_range.map do |x|
        @colors[Vector[x, y]] == 0 ? ' ' : '*'
      end.join
    end.join("\n")
  end
end

Day11.run if __FILE__ == $0

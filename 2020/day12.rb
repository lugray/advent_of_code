#!/usr/bin/env ruby

require_relative 'day'
require 'matrix'

class Turtle
  CLOCKWISE = Matrix[[0, 1], [-1, 0]]
  COUNTER_CLOCKWISE = Matrix[[0, -1], [1, 0]]
  NORTH = Vector[0, 1]
  SOUTH = Vector[0, -1]
  EAST = Vector[1, 0]
  WEST = Vector[-1, 0]

  attr_accessor :position

  def initialize(input, x, y)
    @position = Vector[0, 0]
    @facing = Vector[x, y]
    @instructions = input.each_line.map do |l|
      [l[0], l[1..].to_i]
    end
  end

  def move
    @instructions.each do |(action, value)|
      case action
      when "N"
        cardinal(value * NORTH)
      when "S"
        cardinal(value * SOUTH)
      when "E"
        cardinal(value * EAST)
      when "W"
        cardinal(value * WEST)
      when "R"
        (value / 90).times { @facing = CLOCKWISE * @facing }
      when "L"
        (value / 90).times { @facing = COUNTER_CLOCKWISE * @facing }
      when "F"
        @position += value * @facing
      end
    end
    self
  end

  def cardinal(val)
    @position += val
  end

  def taxi_distance
    position.map(&:abs).inject(:+)
  end
end

class Ferry < Turtle
  def cardinal(val)
    @facing += val
  end
end

class Day12 < Day
  def part_1
    Turtle.new(input, 1, 0).move.taxi_distance
  end

  def part_2
    Ferry.new(input, 10, 1).move.taxi_distance
  end
end

Day12.run if __FILE__ == $0

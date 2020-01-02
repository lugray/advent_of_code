#!/usr/bin/env ruby

require_relative 'day'
require_relative 'intcode'

class Day25 < Day
  def part_1
    intcode = Intcode.new(input.split(',').map(&:to_i))
    intcode.with_inputs(*<<~EOF.each_char.map(&:ord)).run
      west
      south
      take polygon
      north
      east
      north
      west
      take boulder
      east
      north
      take manifold
      west
      south
      east
      south
      take fixed point
      north
      west
      north
      north
      east
      east
      north
    EOF
    intcode.outputs.map(&:chr).join.each_line.to_a.last.scan(/\d+/)
  end

  def part_1_interactive
    intcode = Intcode.new(input.split(',').map(&:to_i))
    loop do
      intcode.run
      print intcode.outputs.map(&:chr).join
      intcode.outputs.clear
      break if intcode.done?
      intcode.with_inputs(*gets.each_char.map(&:ord))
    end
  end

  def part_2
  end
end

Day25.run if __FILE__ == $0

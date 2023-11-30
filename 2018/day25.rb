#!/usr/bin/env ruby

require_relative 'day'

class Day25 < Day
  def initialize
    @stars = input_grid(',')
  end

  def distance(a, b)
    a.zip(b).sum { |x, y| (x - y).abs }
  end

  def part_1
    constellations = @stars.map { |star| [star] }
    loop do
      merged = false
      constellations.combination(2).each do |a, b|
        if a.any? { |star| b.any? { |other| distance(star, other) <= 3 } }
          a.concat(b)
          constellations.delete(b)
          merged = true
        end
      end
      break unless merged
    end
    constellations.count
  end

  def part_2
  end
end

Day25.run if __FILE__ == $0

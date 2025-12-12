#!/usr/bin/env ruby

require_relative 'day'

class Day12 < Day
  class Region
    def initialize(line)
      @size, @shape_counts = line.split(': ').map(&:ints)
    end

    def fits?(shapes)
      if @shape_counts.sum < (@size.first / 3) * (@size.last / 3)
        return true
      elsif shapes.zip(@shape_counts).map { |s, c| s * c }.sum > @size.first * @size.last
        return false
      else
        return "Hell if I know" # Truthy?
      end
    end
  end

  def initialize
    parts = input.split("\n\n")
    @regions = parts.pop.lines { |l| Region.new(l) }
    @shapes = parts.map do |part|
      block = part.lines[1..]
      raise "Bad assumption" unless block.all? { |l| l.size == 3 }
      raise "Bad assumption" unless block.size == 3
      block.join.each_char.count('#')
    end
  end

  def part_1
    @regions.count { |r| r.fits?(@shapes) }
  end

  def part_2
  end
end

Day12.run if __FILE__ == $0

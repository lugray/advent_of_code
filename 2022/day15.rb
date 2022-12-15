#!/usr/bin/env ruby

require_relative 'day'
require 'set'

class Range
  def abs
    a,b = [first, last]
    b -= 1 if exclude_end?
    Range.new(*[a,b].sort)
  end

  def +(other)
    RangeSet.new(self, other)
  end

  def <=>(other)
    (first <=> other.first).nonzero? || (other.last <=> last)
  end
end

class RangeSet
  attr_reader :ranges

  def initialize(*ranges)
    @ranges = simplify(ranges.select { |r| r.size > 0 })
  end

  def simplify(ranges)
    ranges.sort!.each_with_object([]) do |r, rs|
      if rs.any? && rs.last.last+1 >= r.first
        if r.last > rs.last.last
          rs << (rs.pop.first..r.last)
        end
      else
        rs << r
      end
    end
  end

  def +(other)
    case other
    when Range
      RangeSet.new(*@ranges, other)
    when RangeSet
      RangeSet.new(*@ranges, *other.ranges)
    end
  end

  def size
    @ranges.sum(&:size)
  end

  def ==(other)
    @ranges == other.ranges
  end
end

class Day15 < Day
  class Sensor
    attr_reader :x, :y, :bx, :by, :range

    def initialize(x, y, bx, by)
      @x, @y, @bx, @by = x, y, bx, by
      @range = distance(bx, by)
    end

    def distance(x, y)
      (@x - x).abs + (@y - y).abs
    end

    def covers?(x, y)
      distance(x, y) <= range
    end

    def covers_in_row(y, min = nil, max = nil)
      horizontal_range = range - (y - @y).abs
      a = @x - horizontal_range
      b = @x + horizontal_range
      a = [a, min].max if min
      b = [b, max].min if max
      (a..b)
    end
  end

  def initialize
    @sensors = input_lines do |line|
      Sensor.new(*line.scan(/-?\d+/).map(&:to_i))
    end.sort_by(&:range).reverse
    @beacons = Set.new(@sensors.map { |s| [s.bx, s.by] })
  end

  def part_1
    row = ARGV.include?('--example') ? 10 : 2000000
    @sensors.map { |s| s.covers_in_row(row) }.reduce(:+).size - @beacons.count { |_x, y| y == row }
  end

  def part_2
    max = ARGV.include?('--example') ? 20 : 4000000
    y = (0..max).find do |y|
      rs = RangeSet.new
      @sensors.each do |s|
        rs += s.covers_in_row(y, 0, max)
        break false if rs.ranges == [0..max]
      end
    end
    covered = @sensors.map { |s| s.covers_in_row(y, 0, max) }.reduce(:+)
    puts covered.inspect
    x = covered.ranges.find { |r| r.include?(0) }.last + 1
    puts "x=#{x}, y=#{y}"
    x * 4000000 + y
  end
end

Day15.run if __FILE__ == $0

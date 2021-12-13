#!/usr/bin/env ruby

require_relative 'day'

class Day13 < Day
  def initialize
    points, folds = input.split("\n\n")
    @points = points.each_line.map do |l|
      l.chomp.split(',').map(&:to_i)
    end
    @folds = folds.each_line.map do |l|
      c, v = l.split(' ').last.split('=')
      [c, v.to_i]
    end
  end

  def fold(points, fold)
    c, v = fold
    case c
    when 'x'
      points.map do |(x, y)|
        if x < v
          [x, y]
        else
          [2 * v - x, y]
        end
      end
    when 'y'
      points.map do |(x, y)|
        if y < v
          [x, y]
        else
          [x, 2 * v - y]
        end
      end
    else
      raise 'wut'
    end.uniq
  end

  def part_1
    points = fold(@points, @folds.first).count
  end

  def part_2
    points = @points
    @folds.each do |fold|
      points = fold(points, fold)
    end
    Range.new(*points.map(&:last).minmax).map do |y|
      Range.new(*points.map(&:first).minmax).map do |x|
        points.include?([x, y]) ? '#' : ' '
      end.join
    end.join("\n")
  end
end

Day13.run if __FILE__ == $0

#!/usr/bin/env ruby

require_relative 'day'

class Day13 < Day
  def initialize
    points, folds = input.split("\n\n")
    @points = points.each_line.map { |l| l.chomp.split(',').map(&:to_i) }
    @folds = folds.each_line.map do |l|
      l.split(' ').last.split('=').yield_self { |c, v| [c == 'x' ? 0 : 1, v.to_i] }
    end
  end

  def fold(points, fold)
    c, v = fold
    points.map do |p|
      next p if p[c] < v
      p.dup.tap { |p| p[c] = 2 * v - p[c] }
    end.uniq
  end

  def part_1
    points = fold(@points, @folds.first).count
  end

  def part_2
    points = @points
    @folds.each { |fold| points = fold(points, fold) }
    Range.new(*points.map(&:last).minmax).map do |y|
      Range.new(*points.map(&:first).minmax).map do |x|
        points.include?([x, y]) ? '█' : ' '
      end.join
    end.join("\n")
  end
end

Day13.run if __FILE__ == $0

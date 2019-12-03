#!/usr/bin/env ruby

require_relative 'aoc'

class Path
  def initialize(path_str)
    @vecs = process(path_str)
  end

  def each_segment
    return enum_for(:each_segment) unless block_given?
    x = 0
    y = 0
    s = 0
    @vecs.each do |dx, dy|
      yield(x, y, dx, dy, s)
      x += dx
      y += dy
      s += dx.abs + dy.abs
    end
  end

  private

  def process(path_str)
    path_str.split(',').map do |seg_str|
      dir = seg_str[0]
      len = seg_str[1..-1].to_i
      case dir
      when 'R'
        [len, 0]
      when 'L'
        [-len, 0]
      when 'U'
        [0, len]
      when 'D'
        [0, -len]
      end
    end
  end
end

class Crosses
  def initialize(input)
    @path1, @path2 = input.lines.map { |n| Path.new(n.chomp) }
  end

  def each
    return enum_for(:each) unless block_given?

    @path1.each_segment do |x1, y1, dx1, dy1, s1|
      @path2.each_segment do |x2, y2, dx2, dy2, s2|
        rx1 = sorted_range(x1, x1 + dx1)
        ry1 = sorted_range(y1, y1 + dy1)
        rx2 = sorted_range(x2, x2 + dx2)
        ry2 = sorted_range(y2, y2 + dy2)

        s = s1 + s2 + (x2-x1).abs + (y2-y1).abs

        if rx2 === x1 && ry1 === y2
          yield(x1, y2, s)
        elsif rx1 === x2 && ry2 === y1
          yield(x2, y1, s)
        end
      end
    end
  end

  private

  def sorted_range(v1, v2)
    [v1, v2].min..[v1, v2].max
  end
end

crosses = Crosses.new(AOC.input)
puts crosses.each.map { |x, y, _| x.abs + y.abs }.reject { |n| n.zero? }.min
puts crosses.each.map { |_, _, s| s }.reject { |n| n.zero? }.min

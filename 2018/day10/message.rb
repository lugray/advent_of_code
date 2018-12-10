#!/usr/bin/env ruby

class Message
  POINT_LINE = /position=< *(?<x>-?\d+), *(?<y>-?\d+)> velocity=< *(?<vx>-?\d+), *(?<vy>-?\d+)>/
  def initialize(point_str)
    @points = point_str.each_line.map do |line|
      md = POINT_LINE.match(line.chomp)
      Point.new(md[:x].to_i, md[:y].to_i, md[:vx].to_i, md[:vy].to_i)
    end
  end

  def draw_at_narrowest
    draw_at(narrowest)
  end

  # TODO: This could be way more intellgent by looking at the actual speeds rather than checking every t.
  def narrowest
    t = -1
    last_height = Float::INFINITY
    height = Float::INFINITY
    until (height > last_height) do
      t = t + 1
      last_height = height
      points = @points.map { |p| p.pos_at(t) }
      min_y, max_y = points.map(&:last).minmax
      height = max_y - min_y
    end
    t - 1
  end

  def draw_at(t)
    points = @points.map { |p| p.pos_at(t) }
    min_x, max_x = points.map(&:first).minmax
    min_y, max_y = points.map(&:last).minmax
    (min_y..max_y).map do |y|
      (min_x..max_x).map do |x|
        points.include?([x, y]) ? '#' : ' '
      end.join
    end.join("\n")
  end

  class Point
    def initialize(x, y, vx, vy)
      @x = x
      @y = y
      @vx = vx
      @vy = vy
    end

    def pos_at(t)
      [@x + t * @vx, @y + t * @vy]
    end
  end
end

input = 'position=< 9,  1> velocity=< 0,  2>
position=< 7,  0> velocity=<-1,  0>
position=< 3, -2> velocity=<-1,  1>
position=< 6, 10> velocity=<-2, -1>
position=< 2, -4> velocity=< 2,  2>
position=<-6, 10> velocity=< 2, -2>
position=< 1,  8> velocity=< 1, -1>
position=< 1,  7> velocity=< 1,  0>
position=<-3, 11> velocity=< 1, -2>
position=< 7,  6> velocity=<-1, -1>
position=<-2,  3> velocity=< 1,  0>
position=<-4,  3> velocity=< 2,  0>
position=<10, -3> velocity=<-1,  1>
position=< 5, 11> velocity=< 1, -2>
position=< 4,  7> velocity=< 0, -1>
position=< 8, -2> velocity=< 0,  1>
position=<15,  0> velocity=<-2,  0>
position=< 1,  6> velocity=< 1,  0>
position=< 8,  9> velocity=< 0, -1>
position=< 3,  3> velocity=<-1,  1>
position=< 0,  5> velocity=< 0, -1>
position=<-2,  2> velocity=< 2,  0>
position=< 5, -2> velocity=< 1,  2>
position=< 1,  4> velocity=< 2,  1>
position=<-2,  7> velocity=< 2, -2>
position=< 3,  6> velocity=<-1, -1>
position=< 5,  0> velocity=< 1,  0>
position=<-6,  0> velocity=< 2,  0>
position=< 5,  9> velocity=< 1, -2>
position=<14,  7> velocity=<-2,  0>
position=<-3,  6> velocity=< 2, -1>
'

input = File.read('input')

puts Message.new(input).draw_at_narrowest
puts Message.new(input).narrowest

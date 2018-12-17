#!/usr/bin/env ruby
require "English"

class Water
  def initialize(input)
    @map = Hash.new(' ')
    @y_min = Float::INFINITY
    @y_max = -Float::INFINITY
    @x_min = Float::INFINITY
    @x_max = -Float::INFINITY

    input.each_line do |line|
      line = line.chomp
      case line
      when /y=(?<y>\d+), x=(?<x_min>\d+)..(?<x_max>\d+)/
        y = $LAST_MATCH_INFO['y'].to_i
        x_min = $LAST_MATCH_INFO['x_min'].to_i
        x_max = $LAST_MATCH_INFO['x_max'].to_i
        (x_min..x_max).each do |x|
          @map[[x,y]] = '#'
        end
        @y_min = [@y_min, y].min
        @y_max = [@y_max, y].max
        @x_min = [@x_min, x_min].min
        @x_max = [@x_max, x_max].max
      when /x=(?<x>\d+), y=(?<y_min>\d+)..(?<y_max>\d+)/
        x = $LAST_MATCH_INFO['x'].to_i
        y_min = $LAST_MATCH_INFO['y_min'].to_i
        y_max = $LAST_MATCH_INFO['y_max'].to_i
        (y_min..y_max).each do |y|
          @map[[x,y]] = '#'
        end
        @y_min = [@y_min, y_min].min
        @y_max = [@y_max, y_max].max
        @x_min = [@x_min, x].min
        @x_max = [@x_max, x].max
      end
    end
    flow
  end

  def count
    @map.values.count { |l| l == '~' || l == '|' }
  end

  def count_drained
    @map.values.count { |l| l == '~' }
  end

  private

  def flow(x=500, y=@y_min)
    return false if y > @y_max || @map[[x,y]] == '|'
    return true if @map[[x,y]] == '#' || @map[[x,y]] == '~'
    @map[[x,y]] = '|'
    return false unless flow(x, y+1)
    flow_out(x,y)
  end

  def mark_out(x,y,delta=nil)
    return if @map[[x,y]] == '#'
    @map[[x,y]] = '~'
    mark_out(x+delta, y, delta)
  end

  def flow_out(x, y, delta = nil)
    if delta.nil?
      fl = flow_out(x-1, y, -1)
      fr = flow_out(x+1, y, 1)
      if fl && fr
        mark_out(x+1,y, 1)
        mark_out(x-1,y, -1)
        return true
      else
        return false
      end
    end
    return true if @map[[x,y]] == '#'
    @map[[x,y]] = '|'
    flow(x, y+1) && flow_out(x+delta, y, delta)
  end

  def to_s
    (@y_min..@y_max).map do |y|
      (@x_min-1..@x_max+1).map do |x|
        @map[[x,y]]
      end.join
    end.join("\n")
  end
end

input = 'x=495, y=2..7
y=7, x=495..501
x=501, y=3..7
x=498, y=2..4
x=506, y=1..2
x=498, y=10..13
x=504, y=10..13
y=13, x=498..504
'

input = File.read('input')

w = Water.new(input)
puts w.count
puts w.count_drained

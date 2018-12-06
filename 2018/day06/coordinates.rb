#!/usr/bin/env ruby

class CoordinateList
  def initialize(str)
    @list = str.lines.map do |line|
      x, y = line.chomp.split(', ').map(&:to_i)
      Coordinate.new(x, y)
    end
  end

  def areas
    initial = (left..right).flat_map do |x|
      (bottom..top).map do |y|
        c1 = Coordinate.new(x, y)
        mins = @list.min_by(2) do |c2|
          c1 - c2
        end
        if mins.first != mins.last
          mins.first
        end
      end
    end.compact.group_by(&:itself).transform_values(&:length)
    border = (left..right).zip([top].cycle) +
      (left..right).zip([bottom].cycle) +
      (bottom..top).zip([left].cycle) +
      (bottom..top).zip([right].cycle)
    infinite_areas = border.map do |x,y|
      c1 = Coordinate.new(x,y)
      mins = @list.min_by(2) do |c2|
        c1 - c2
      end
      if mins.first != mins.last
        mins.first
      end
    end.compact.uniq
    # initial.reject do |coord, area|
    #   infinite_areas.include?(coord)
    # end
  end

  def left
    @list.min_by(&:x).x
  end

  def right
    @list.max_by(&:x).x
  end

  def bottom
    @list.min_by(&:y).y
  end

  def top
    @list.max_by(&:y).y
  end

  class Coordinate
    attr_reader :x, :y
    def initialize(x, y)
      @x = x
      @y = y
    end

    def -(other)
      (@x - other.x).abs + (@y - other.y).abs
    end

    def to_s
      "(#{x}, #{y})"
    end
  end
end

input ='1, 1
1, 6
8, 3
3, 4
5, 5
8, 9
'

cl = CoordinateList.new(input)
puts cl.areas

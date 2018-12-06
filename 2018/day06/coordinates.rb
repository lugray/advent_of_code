#!/usr/bin/env ruby

class CoordinateList
  def initialize(str)
    @list = str.lines.map do |line|
      x, y = line.chomp.split(', ').map(&:to_i)
      Coordinate.new(x, y)
    end
  end

  def max_area
    areas.values.max
  end

  def region_size(max_dist_sum = 10000)
    board.count do |c|
      dist_sum(c) < max_dist_sum
    end
  end

  private

  def dist_sum(c1)
    @list.inject(0) do |sum, c2|
      sum + (c2 - c1)
    end
  end

  def board
    return enum_for(:board) unless block_given?
    (left..right).each do |x|
      (bottom..top).each do |y|
        yield Coordinate.new(x, y)
      end
    end
  end

  def areas
    initial = board.map { |c| closest(c) }.compact.group_by(&:itself).transform_values(&:length)
    infinite_areas = border.map { |c| closest(c) }.compact.uniq
    initial.reject { |coord, area| infinite_areas.include?(coord) }
  end

  def border
    @border ||= ((left..right).zip([top].cycle) +
      (left..right).zip([bottom].cycle) +
      (bottom..top).zip([left].cycle).map(&:reverse) +
      (bottom..top).zip([right].cycle).map(&:reverse)).map do |x, y|
        Coordinate.new(x, y)
      end
  end

  def closest(c1)
    mins = @list.min_by(2) do |c2|
      c1 - c2
    end
    if mins.first - c1 != mins.last - c1
      mins.first
    end
  end

  def left
    @left ||= @list.min_by(&:x).x
  end

  def right
    @right ||= @list.max_by(&:x).x
  end

  def bottom
    @bottom ||= @list.min_by(&:y).y
  end

  def top
    @top ||= @list.max_by(&:y).y
  end

  class Coordinate
    attr_reader :x, :y
    def initialize(x, y, id = nil)
      @x = x
      @y = y
    end

    def -(other)
      (@x - other.x).abs + (@y - other.y).abs
    end

    def ==(other)
      self - other == 0
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
puts cl.max_area
puts cl.region_size(32)

input = File.read('input')
cl = CoordinateList.new(input)
puts cl.max_area
puts cl.region_size

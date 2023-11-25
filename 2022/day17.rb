#!/usr/bin/env ruby

require_relative 'day'

class Day17 < Day
  class Rock
    def initialize(y, parts)
      @y = y
      @x = 2
      @parts = parts
    end

    def drop(tower, gas)
      loop do
        push(tower, gas.next)
        break unless fall(tower)
      end
    end

    def push(tower, delta)
      @x += delta if can_push?(tower, delta)
    end

    def fall(tower)
      if can_fall?(tower)
        @y -= 1
        return true
      end

      freeze(tower)
      false
    end

    def each_coordinate
      return enum_for(:each_coordinate) unless block_given?
      @parts.each do |x, y|
        yield @x + x, @y + y
      end
    end

    def can_push?(tower, delta)
      each_coordinate.all? do |x, y|
        !tower.has?(x + delta, y)
      end
    end

    def can_fall?(tower)
      return false if @y == 0
      each_coordinate.all? do |x, y|
        !tower.has?(x, y - 1)
      end
    end

    def freeze(tower)
      each_coordinate do |x, y|
        tower.place(x, y)
      end
    end
  end

  # ####
  PARTS1 = [
    [0, 0],
    [1, 0],
    [2, 0],
    [3, 0],
  ]

  #  #
  # ###
  #  #
  PARTS2 = [
    [1, 2],
    [0, 1],
    [1, 1],
    [2, 1],
    [1, 0],
  ]

  #   #
  #   #
  # ###
  PARTS3 = [
    [2, 2],
    [2, 1],
    [0, 0],
    [1, 0],
    [2, 0],
  ]

  # #
  # #
  # #
  # #
  PARTS4 = [
    [0, 3],
    [0, 2],
    [0, 1],
    [0, 0],
  ]

  # ##
  # ##
  PARTS5 = [
    [0, 1],
    [1, 1],
    [0, 0],
    [1, 0],
  ]


  class Tower
    attr_reader :height

    def initialize
      @tower = []
      @height = 0
    end

    def has?(x, y)
      return true if x < 0 || x >= 7
      @tower[y] ||= 0
      @tower[y] & (1 << x) != 0
    end

    def place(x, y)
      @tower[y] ||= 0
      @tower[y] |= (1 << x)
      @height = [y + 1, @height].max
    end

    def draw
      @height.downto(0) do |y|
        puts @tower[y].to_s(2).rjust(7, '0').tr('01', '.#').reverse
      end
    end

    def [](y)
      @tower[y]
    end
  end

  def initialize
    @gas = input.chomp.each_char.map do |c|
      case c
      when '<' then -1
      when '>' then 1
      else raise "Unknown gas char #{c}"
      end
    end
  end

  def part_1
    gas = @gas.cycle
    tower = Tower.new
    parts = [PARTS1, PARTS2, PARTS3, PARTS4, PARTS5].cycle
    2022.times do
      Rock.new(tower.height + 3, parts.next).drop(tower, gas)
    end
    tower.height
  end

  class CycleWithIndex
    attr_reader :index

    def initialize(array)
      @array = array
      @index = 0
    end

    def next
      @array[@index].tap do
        @index = (@index + 1) % @array.size
      end
    end
  end

  def check_cycle(tower, marker_heights)
    h = marker_heights.dup
    top = h.pop
    h.each_with_index.reverse_each do |middle, i|
      bottom = middle - (top - middle)
      next unless h.include?(bottom)
      return i if tower[bottom..middle] == tower[middle..top]
    end
    nil
  end

  def part_2
    tower = Tower.new
    gas = CycleWithIndex.new(@gas)
    parts = CycleWithIndex.new([PARTS1, PARTS2, PARTS3, PARTS4, PARTS5])
    i = 0
    marker_heights = Hash.new { |h, k| h[k] = [] }
    marker_indices = Hash.new { |h, k| h[k] = [] }
    top_index = middle_index = nil
    cycle_height = nil
    loop do
      Rock.new(tower.height + 3, parts.next).drop(tower, gas)
      i += 1
      if !top_index.nil? && (1000000000000 - i) % (top_index - middle_index) == 0
        return tower.height + (1000000000000 - i) / (top_index - middle_index) * cycle_height
      end
      if parts.index == 0 && top_index.nil?
        marker_heights[gas.index] << tower.height - 1
        marker_indices[gas.index] << i
        if marker_heights[gas.index].size > 2
          if j = check_cycle(tower, marker_heights[gas.index])
            top_index = i
            middle_index = marker_indices[gas.index][j]
            cycle_height = tower.height - marker_heights[gas.index][j] - 1
          end
        end
      end
    end
  end
end

Day17.run if __FILE__ == $0

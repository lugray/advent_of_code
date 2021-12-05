#!/usr/bin/env ruby

require_relative 'day'

class Day05 < Day
  class Vent
    attr_reader :x1, :y1, :x2, :y2

    def initialize(x1, y1, x2, y2)
      @x1 = x1
      @y1 = y1
      @x2 = x2
      @y2 = y2
    end

    def horizontal?
      y1 == y2
    end

    def vertical?
      x1 == x2
    end

    def points
      return enum_for(:points).to_a unless block_given?
      delta_x = x2 <=> x1
      delta_y = y2 <=> y1
      size = [(x2 - x1).abs, (y2 - y1).abs].max
      (0..size).each do |d|
        yield([x1 + d * delta_x, y1 + d * delta_y])
      end
    end
  end

  def initialize
    @vents = input_lines.map do |l|
      vals = l.split(' -> ').flat_map do |pair|
        pair.split(',').map(&:to_i)
      end
      Vent.new(*vals)
    end
  end

  def count_overlaps(vents)
    vents.flat_map(&:points).tally.count { |_, c| c > 1 }
  end

  def part_1
    count_overlaps(@vents.select { |v| v.horizontal? || v.vertical? })
  end

  def part_2
    count_overlaps(@vents)
  end
end

Day05.run if __FILE__ == $0

#!/usr/bin/env ruby

require_relative 'day'

class Range
  def overlap?(other)
    return false if size.zero? || other.size.zero?
    include?(other.first) || include?(other.last) || other.include?(first)
  end
end

class Day22 < Day
  class Box

    attr_reader :ranges

    def initialize(ranges)
      @ranges = ranges
    end

    def overlap?(other)
      ranges.zip(other.ranges).all? { |r1, r2| r1.overlap?(r2) }
    end

    def size
      ranges.map(&:size).inject(&:*)
    end

    def -(other)
      return self unless overlap?(other)
      new_ranges = ranges.zip(other.ranges).map do |r1, r2|
        a, b, c, d = [r1.first, r1.last, r2.first, r2.last].sort
        [(a..b-1), (b..c), (c+1..d)]
      end
      [0, 1, 2].repeated_permutation(3).map do |address|
        Box.new(new_ranges.zip(address).map { |rs, i| rs[i] })
      end.reject do |box|
        box.size.zero? || box.overlap?(other) || !box.overlap?(self)
      end
    end
  end

  def initialize
    @instructions = input_lines.map do |line|
      state, rest = line.split(' ')
      ranges = rest.split(',').map { |p| eval(p[2..]) }
      [state == 'on', Box.new(ranges)]
    end
  end

  def count_on(instructions)
    boxes = []
    instructions.each do |on, box|
      boxes = boxes.flat_map { |b| b - box }
      boxes << box if on
    end
    boxes.sum(&:size)
  end

  def part_1
    count_on(@instructions.select { |_, box| box.ranges.flat_map(&:minmax).map(&:abs).max <= 50 })
  end

  def part_2
    count_on(@instructions)
  end
end

Day22.run if __FILE__ == $0

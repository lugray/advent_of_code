#!/usr/bin/env ruby

require_relative 'day'

class Day05 < Day
  class Map
    def initialize(input)
      @map = input.lines(chomp: true).drop(1).map { |line| line.split(' ').map(&:to_i) }.sort_by { |_, from, _| from }
    end

    def transform(value)
      to, from, size = @map.find { |_, from, size| from <= value && value < from + size }
      return value unless from
      to + value - from
    end

    def transform_range(range)
      to, from, size = @map.find { |_, from, size| from <= range.min && range.min < from + size }
      result = if from
        v1 = to + range.min - from
        v2 = [to + range.max - from, to + size - 1].min
        v1..v2
      else
        to, from, size = @map.find { |_, from, size| range.include?(from) }
        if from
          range.min..(from-1)
        else
          range
        end
      end
      return [result] if result.size == range.size
      [result] + transform_range((range.min + result.size)..range.max)
    end

    def transform_ranges(ranges)
      ranges.flat_map { |range| transform_range(range) }
    end
  end

  def initialize
    seeds, rest = input.split("\n\n", 2)
    @seeds = seeds.split(': ').last.split(' ').map(&:to_i)
    @maps = rest.split("\n\n").map { |map| Map.new(map) }
  end

  def part_1
    @seeds.map do |seed|
      @maps.reduce(seed) do |value, map|
        map.transform(value)
      end
    end.min
  end

  def part_2
    @seeds.each_slice(2).map do |start, size|
      range = (start..(start + size - 1))
      @maps.reduce([range]) do |ranges, map|
        map.transform_ranges(ranges)
      end.map(&:first).min
    end.min
  end
end

Day05.run if __FILE__ == $0

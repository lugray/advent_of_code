#!/usr/bin/env ruby

require_relative 'day'

class Range
  def &(other) = [min, other.min].max..[max, other.max].min
  def +(offset) = min + offset..max + offset
  def exclude(other) = [min...[min, other.min].max, [max, other.max].min+1..max].select(&:any?)
end

class Day05 < Day
  class Map
    def initialize(input)
      @map = input.lines(chomp: true).drop(1).map(&:ints).map { |to, from, size| [(from...from+size), to - from] }
    end

    def transform(value)
      offset = @map.find { |range, _| range.include?(value) }&.last || 0
      value + offset
    end

    def transform_ranges(ranges)
      ranges.flat_map do |range|
        map_range, offset = @map.find { |map_range, _| (range & map_range).any? }
        next range unless map_range
        [(range & map_range) + offset] + transform_ranges(range.exclude(map_range))
      end
    end
  end

  def initialize
    seeds, *maps = input_paragraphs
    @seeds = seeds.ints
    @maps = maps.map { |map| Map.new(map) }
  end

  def part_1
    @seeds.map do |seed|
      @maps.reduce(seed) { |value, map| map.transform(value) }
    end.min
  end

  def part_2
    seed_ranges = @seeds.each_slice(2).map { |start, size| start...start+size }
    @maps.reduce(seed_ranges) { |ranges, map| map.transform_ranges(ranges) }.map(&:min).min
  end
end

Day05.run if __FILE__ == $0

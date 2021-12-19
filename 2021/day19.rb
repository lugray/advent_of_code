#!/usr/bin/env ruby

require_relative 'day'
require 'matrix'

class Day19 < Day
  class Rotations
    COS = [1, 0, -1, 0]
    SIN = [0, 1, 0, -1]

    class << self
      def rx(a)
        c = COS[a]
        s = SIN[a]

        Matrix[
          [1, 0, 0],
          [0, c, -s],
          [0, s, c],
        ]
      end

      def ry(a)
        c = COS[a]
        s = SIN[a]

        Matrix[
          [c, 0, s],
          [0, 1, 0],
          [-s, 0, c],
        ]
      end

      def rz(a)
        c = COS[a]
        s = SIN[a]

        Matrix[
          [c, -s, 0],
          [s, c, 0],
          [0, 0, 1],
        ]
      end

      def all_rots
        (0..3).flat_map do |nx|
          (0..3).flat_map do |ny|
            (0..3).map do |nz|
              rx(nx) * ry(ny) * rz(nz)
            end
          end
        end.uniq
      end
    end
  end

  class Scanner
    ROTATIONS = Rotations.all_rots

    attr_reader :beacons

    def initialize(points)
      @beacons = points
    end

    def alt_rots
      @alt_rots ||= ROTATIONS.map do |r|
        Scanner.new(@beacons.map { |b| r * b })
      end
    end

    def match(other)
      alt_rots.each do |ar|
        if offset = ar.offset_match(other)
          @beacons = ar.beacons.map { |b| b + offset }
          return offset
        end
      end
      false
    end

    def offset_match(other)
      counts = Hash.new(0)
      beacons.each do |b|
        other.beacons.each do |ob|
          diff = ob -b
          counts[diff] += 1
          if counts[diff] == 12
            return diff
          end
        end
      end
      false
    end
  end

  def initialize
    @scanners = input.split("\n\n").map do |lines|
      _label, *point_lines = lines.split("\n")
      Scanner.new(point_lines.map { |pl| Matrix.column_vector(pl.split(',').map(&:to_i)) })
    end
  end

  def part_1
    @offsets = [Matrix.column_vector([0, 0, 0])]
    matched = @scanners.shift
    while @scanners.any? do
      scanner = @scanners.shift
      if (offset = scanner.match(matched))
        @offsets << offset
        matched = Scanner.new((matched.beacons + scanner.beacons).uniq)
      else
        @scanners.push(scanner)
      end
    end
    matched.beacons.count
  end

  def part_2
    dist = 0
    @offsets.each do |a|
      @offsets.each do |b|
        dist = [dist, (a-b).to_a.flatten.map(&:abs).sum].max
      end
    end
    dist
  end
end

Day19.run if __FILE__ == $0

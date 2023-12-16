#!/usr/bin/env ruby

require_relative 'day'
require 'matrix'

class Day16 < Day
  def initialize
    @map = {}
    input_lines.each_with_index do |line, r|
      line.each_char.each_with_index do |char, c|
        @map[Vector[r, c]] = char
      end
    end
  end

  def propogate(p, dir, beams)
    return unless @map.key?(p)
    beams[p] ||= Set.new
    return if beams[p].include?(dir)
    beams[p] << dir

    case @map[p]
    when '.'
      propogate(p + dir, dir, beams)
    when '\\'
      Vector[dir[1], dir[0]].tap { |dir| propogate(p + dir, dir, beams) }
    when '/'
      Vector[-dir[1], -dir[0]].tap { |dir| propogate(p + dir, dir, beams) }
    when '-'
      if dir[0].zero?
        propogate(p + dir, dir, beams)
      else
        Vector[0, -1].tap { |dir| propogate(p + dir, dir, beams) }
        Vector[0, 1].tap { |dir| propogate(p + dir, dir, beams) }
      end
    when '|'
      if dir[1].zero?
        propogate(p + dir, dir, beams)
      else
        Vector[-1, 0].tap { |dir| propogate(p + dir, dir, beams) }
        Vector[1, 0].tap { |dir| propogate(p + dir, dir, beams) }
      end
    end
  end

  def count_from(p, dir)
    beams = {}
    propogate(p, dir, beams)
    beams.count
  end

  def part_1
    count_from(Vector[0, 0], Vector[0, 1])
  end

  def part_2
    min_r, max_r = @map.keys.map { |p| p[0] }.minmax
    min_c, max_c = @map.keys.map { |p| p[1] }.minmax
    max = TrackMax.new
    (min_r..max_r).each do |r|
      max << count_from(Vector[r, min_c], Vector[0, 1])
      max << count_from(Vector[r, max_c], Vector[0, -1])
    end
    (min_c..max_c).each do |c|
      max << count_from(Vector[min_r, c], Vector[1, 0])
      max << count_from(Vector[max_r, c], Vector[-1, 0])
    end
    max.max
  end
end

Day16.run if __FILE__ == $0

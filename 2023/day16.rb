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
      dir = Vector[dir[1], dir[0]]
      propogate(p + dir, dir, beams)
    when '/'
      dir = Vector[-dir[1], -dir[0]]
      propogate(p + dir, dir, beams)
    when '-'
      if dir[0] == 0
        propogate(p + dir, dir, beams)
      else
        propogate(p + Vector[0, -1], Vector[0, -1], beams)
        propogate(p + Vector[0, 1], Vector[0, 1], beams)
      end
    when '|'
      if dir[1] == 0
        propogate(p + dir, dir, beams)
      else
        propogate(p + Vector[-1, 0], Vector[-1, 0], beams)
        propogate(p + Vector[1, 0], Vector[1, 0], beams)
      end
    end
  end

  def part_1
    beams = {}
    propogate(Vector[0, 0], Vector[0, 1], beams)
    beams.count
  end

  def part_2
    min_r, max_r = @map.keys.map { |p| p[0] }.minmax
    min_c, max_c = @map.keys.map { |p| p[1] }.minmax
    starts = []
    (min_r..max_r).each do |r|
      starts << [Vector[r, min_c], Vector[0, 1]]
      starts << [Vector[r, max_c], Vector[0, -1]]
    end
    (min_c..max_c).each do |c|
      starts << [Vector[min_r, c], Vector[1, 0]]
      starts << [Vector[max_r, c], Vector[-1, 0]]
    end
    starts.map do |p, dir|
      beams = {}
      propogate(p, dir, beams)
      beams.count
    end.max
  end
end

Day16.run if __FILE__ == $0

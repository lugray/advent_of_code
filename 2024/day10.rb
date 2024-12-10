#!/usr/bin/env ruby

require_relative 'day'

class Day10 < Day
  def initialize
    @map = {}
    @reaches = {}
    input_lines.each_with_index do |line, row|
      line.each_char.each_with_index do |char, col|
        @map[[row, col]] = char.to_i
      end
    end
  end

  def neighbors(pos)
    r, c = pos
    [[r - 1, c], [r + 1, c], [r, c - 1], [r, c + 1]]
  end

  def reaches(pos)
    @reaches[pos] ||= if @map[pos] == 9
      [pos]
    else
      neighbors(pos).flat_map { |n| @map[n] == @map[pos] + 1 ? reaches(n) : [] }
    end
  end

  def part_1
    @map.sum { |pos, value| value == 0 ? reaches(pos).uniq.size : 0 }
  end

  def part_2
    @map.sum { |pos, value| value == 0 ? reaches(pos).size : 0 }
  end
end

Day10.run if __FILE__ == $0

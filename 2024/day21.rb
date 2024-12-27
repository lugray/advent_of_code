#!/usr/bin/env ruby

require_relative 'day'

class Day21 < Day
  NUM = 0
  DIR = 1
  PAD = []
  PAD[NUM] = [
    ['7', '8', '9'],
    ['4', '5', '6'],
    ['1', '2', '3'],
    [nil, '0', 'A'],
  ]
  PAD[DIR] = [
    [nil, '^', 'A'],
    ['<', 'v', '>'],
  ]

  def initialize
    @codes = input_lines
    @location = {}
    @paths = {}
    @shortest_sequence = {}
  end

  def location(key, pad)
    @location[[key, pad]] ||= find_location(key, pad)
  end

  def find_location(key, pad)
    PAD[pad].each_with_index do |row, r|
      row.each_with_index do |char, c|
        return [r, c] if char == key
      end
    end
  end

  def paths(s, e, pad)
    @paths[[s, e, pad]] ||= find_paths(s, e, pad)
  end

  def find_paths(s, e, pad)
    sr, sc = location(s, pad)
    er, ec = location(e, pad)
    dr = er - sr
    dc = ec - sc
    possibilities = []
    if PAD[pad][sr+dr][sc]
      possibilities << (dr > 0 ? 'v' : '^') * dr.abs + (dc > 0 ? '>' : '<') * dc.abs + 'A'
    end
    if PAD[pad][sr][sc+dc]
      possibilities << (dc > 0 ? '>' : '<') * dc.abs + (dr > 0 ? 'v' : '^') * dr.abs + 'A'
    end
    possibilities.uniq
  end

  def shortest_sequence(str, dirpad_count: 3, depth: 0)
    @shortest_sequence[[str, dirpad_count, depth]] ||= find_shortest_sequence(str, dirpad_count: dirpad_count, depth: depth)
  end

  def find_shortest_sequence(str, dirpad_count:, depth:)
    pad = depth.zero? ? NUM : DIR
    return str.length if depth == dirpad_count
    l = 0
    ('A' + str).each_char.each_cons(2).map do |a, b|
      l += (paths(a, b, pad).map do |path|
        shortest_sequence(path, dirpad_count:, depth: depth + 1)
      end.min)
    end
    l
  end

  def part_1
    @codes.sum { |code| shortest_sequence(code) * code.to_i }
  end

  def part_2
    @codes.sum { |code| shortest_sequence(code, dirpad_count: 26) * code.to_i }
  end
end

Day21.run if __FILE__ == $0

#!/usr/bin/env ruby

require_relative 'day'
require 'matrix'

class Day04 < Day
  def initialize
    @word_search = input_lines.each_with_index.each_with_object({}) do |(line, i), hash|
      line.each_char.each_with_index { |char, j| hash[Vector[i, j]] = char }
    end
  end

  def each_pos(&block)
    @word_search.each_key(&block)
  end

  def has_word?(word_search, word, pos, dir)
    (0...word.size).all? { |i| word_search[pos + dir * i] == word[i] }
  end

  def each_direction
    return enum_for(__method__) unless block_given?
    (-1..1).to_a.repeated_permutation(2).each do |di, dj|
      next if di.zero? && dj.zero?
      yield Vector[di, dj]
    end
  end

  def all_direction_count(word_search, word, pos)
    each_direction.count { |dir| has_word?(word_search, word, pos, dir) }
  end

  def x_word?(word_search, word, pos)
    (has_word?(word_search, word, pos, Vector[1, 1]) || has_word?(word_search, word, pos + Vector[1, 1] * (word.size-1), Vector[-1, -1])) &&
      (has_word?(word_search, word, pos + Vector[1, 0] * (word.size-1), Vector[-1, 1]) || has_word?(word_search, word, pos +  Vector[0, 1] * (word.size-1), Vector[1, -1]))
  end

  def part_1
    each_pos.sum { |pos| all_direction_count(@word_search, 'XMAS', pos) }
  end

  def part_2
    each_pos.count { |pos| x_word?(@word_search, 'MAS', pos) }
  end
end

Day04.run if __FILE__ == $0

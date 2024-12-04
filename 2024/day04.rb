#!/usr/bin/env ruby

require_relative 'day'

class Day04 < Day
  def initialize
    @word_search = input_lines.map { |line| line.each_char.to_a }
  end

  def count_horizontal(word_search, word)
    word_search.sum { |line| line.join('').scan(/(?=#{word})/).count }
  end

  def count_diagonal(word_search, word)
    (0..word_search.size - word.size).sum do |i|
      (0..word_search[0].size - word.size).count do |j|
        (0...word.size).all? { |k| word_search[i + k][j + k] == word[k] }
      end
    end
  end

  def count_all(word_search, word)
    4.times.sum do
      word_search = word_search.transpose.reverse # rotate 90 degrees
      count_horizontal(word_search, word) + count_diagonal(word_search, word)
    end
  end

  def part_1
    count_all(@word_search, 'XMAS')
  end

  def part_2
    word = 'MAS'
    (0..@word_search.size - word.size).sum do |i|
      (0..@word_search[0].size - word.size).count do |j|
        a = (0...3).map { |k| @word_search[i + k][j + k] }.join # \
        b = (0...3).map { |k| @word_search[i + k][j + 2 - k] }.join # /
        ([word, word.reverse] + [a, b]).uniq.size == 2
      end
    end
  end
end

Day04.run if __FILE__ == $0

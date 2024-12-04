#!/usr/bin/env ruby

require_relative 'day'

class Day04 < Day
  def initialize
    @word_search = input_lines.map { |line| line.each_char.to_a }
  end

  def count_horizontal(word_search, word = 'XMAS')
    word_search.sum { |line| line.join('').scan(/(?=#{word})/).count }
  end

  def count_diagonal(word_search, word = 'XMAS')
    (0..word_search.size - word.size).sum do |i|
      (0..word_search[0].size - word.size).count do |j|
        (0...word.size).all? { |k| word_search[i + k][j + k] == word[k] }
      end
    end
  end

  def count_all(word_search, word = 'XMAS')
    count_diagonal(@word_search) +
      count_diagonal(@word_search.reverse) +
      count_diagonal(@word_search.map(&:reverse)) +
      count_diagonal(@word_search.reverse.map(&:reverse)) +
      count_horizontal(@word_search) +
      count_horizontal(@word_search.map(&:reverse)) +
      count_horizontal(@word_search.transpose) +
      count_horizontal(@word_search.transpose.map(&:reverse))
  end

  def part_1
    count_all(@word_search)
  end

  def part_2
    (0..@word_search.size - 3).sum do |i|
      (0..@word_search[0].size - 3).count do |j|
        a = (0...3).map { |k| @word_search[i + k][j + k] }.join
        b = (0...3).map { |k| @word_search[i + k][j + 2 - k] }.join
        (["MAS", "SAM"] + [a, b]).uniq.size == 2
      end
    end
  end
end

Day04.run if __FILE__ == $0

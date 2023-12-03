#!/usr/bin/env ruby

require_relative 'day'

class Day03 < Day
  def initialize
    @grid = {}
    input_lines.each_with_index do |line, r|
      line.chars.each_with_index do |char, c|
        @grid[[r, c]] = char
      end
    end
  end

  def around(r, col_range)
    return enum_for(:around, r, col_range) unless block_given?
    (r-1..r+1).each do |r|
      yield [r, col_range.min - 1]
      yield [r, col_range.max + 1]
    end
    col_range.each do |c|
      yield [r - 1, c]
      yield [r + 1, c]
    end
  end

  def numbers_with_surrounding
    return enum_for(:numbers_with_surrounding) unless block_given?
    input_lines.each_with_index do |line, r|
      c = 0
      line.chars.chunk { |c| /\d/.match?(c) }.each do |is_num, chars|
        yield chars.join.to_i, around(r, c...c + chars.size) if is_num
        c += chars.size
      end
    end
  end

  def part_1
    numbers_with_surrounding.each_with_object([]) do |(num, surrounding), parts|
      parts << num if surrounding.any? { |r, c| /[^\d.]/.match?(@grid[[r, c]]) }
    end.sum
  end

  def part_2
    numbers_with_surrounding.each_with_object(Hash.new { |h, k| h[k] = [] }) do |(num, surrounding), asterisk_numbers|
      surrounding.select { |r, c| @grid[[r, c]] == '*' }.each do |r, c|
        asterisk_numbers[[r, c]] << num
      end
    end.values.select { |nums| nums.size == 2 }.sum { |nums| nums.inject(:*) }
  end
end

Day03.run if __FILE__ == $0

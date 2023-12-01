#!/usr/bin/env ruby

require_relative 'day'

class Day01 < Day
  DIGITS = %w(zero one two three four five six seven eight nine).each_with_index.to_h

  def part_1
    input_lines do |line|
      digits = line.scan(/\d/).map(&:to_i)
      10 * digits.first + digits.last
    end.sum
  end

  def part_2
    regex = Regexp.new("(?=(#{(DIGITS.keys << '\d').join('|')}))") # lookahead to match overlapping digit names
    input_lines do |line|
      digits = line.scan(regex).map { |(d)| DIGITS[d] || d.to_i }
      10 * digits.first + digits.last
    end.sum
  end
end

Day01.run if __FILE__ == $0

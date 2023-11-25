#!/usr/bin/env ruby

require_relative 'day'

class String
  def un_snafu
    chars.reverse.each_with_index.sum do |c, i|
      d = case c
      when '=' then -2
      when '-' then -1
      when '0'..'2' then c.to_i
      else raise "Unexpected char #{c}"
      end
      d * 5**i
    end
  end
end

class Integer
  def snafu
    n = self
    s = []
    while n != 0
      d = n % 5
      case d
      when 0, 1, 2
        s << d.to_s
        n -= d
      when 3
        s << '='
        n += 2
      when 4
        s << '-'
        n += 1
      end
      n /= 5
    end
    s.reverse.join
  end
end

class Day25 < Day
  def initialize
    @snafus = input.each_line(chomp: true)
  end

  def part_1
    @snafus.map(&:un_snafu).inject(:+).snafu
  end

  def part_2
  end
end

Day25.run if __FILE__ == $0

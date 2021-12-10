#!/usr/bin/env ruby

require_relative 'day'

class Day25 < Day
  def initialize
    @row, @col = input.split(/[,. ]/).map(&:to_i).reject(&:zero?)
  end

  def rc_to_n(r, c)
    (r + c - 1) * (r + c) / 2 - r + 1
  end

  def exp_mod_p(b, e, p)
    case e
    when 0
      1
    when 1
      b % p
    when proc(&:even?)
      exp_mod_p(b * b % p, e / 2, p) % p
    else
      b * exp_mod_p(b * b % p, (e - 1) / 2, p) % p
    end
  end

  def part_1
    20151125 * exp_mod_p(252533, rc_to_n(@row, @col) - 1, 33554393) % 33554393
  end

  def part_2
  end
end

Day25.run if __FILE__ == $0

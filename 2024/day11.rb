#!/usr/bin/env ruby

require_relative 'day'

class Day11 < Day
  def initialize
    @list = input.split(' ').map(&:to_i)
    @size_after = {}
  end

  def size_after(val, blinks)
    @size_after[[val, blinks]] ||= begin
      return 1 if blinks == 0
      return size_after(1, blinks-1) if val == 0
      if (s = Math.log(val, 10).floor + 1).even?
        a, b = val.divmod(10**(s / 2))
        size_after(a, blinks-1) + size_after(b, blinks-1)
      else
        size_after(val * 2024, blinks-1)
      end
    end
  end

  def part_1
    @list.sum { |v| size_after(v, 25) }
  end

  def part_2
    @list.sum { |v| size_after(v, 75) }
  end
end

Day11.run if __FILE__ == $0

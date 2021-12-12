#!/usr/bin/env ruby

require_relative 'day'

class Day11 < Day
  def initialize
    @energies = {}
    input_lines.each_with_index do |l, y|
      l.chomp.chars.each_with_index do |c, x|
        @energies[[x, y]] = c.to_i
      end
    end
  end

  def inc(x, y)
    return unless @energies[[x, y]]
    @energies[[x, y]] += 1
    if @energies[[x, y]] == 10
      (x-1..x+1).each do |nx|
        (y-1..y+1).each do |ny|
          next if x == nx && y == ny
          inc(nx, ny)
        end
      end
    end
  end

  def step
    @energies.each_key do |x, y|
      inc(x, y)
    end
    flashes = 0
    @energies.transform_values! do |e|
      if e > 9
        flashes += 1
        0
      else
        e
      end
    end
    flashes
  end

  def part_1
    100.times.sum { step }
  end

  def part_2
    (1..).each do |n|
      return n+100 if step == 100
    end
  end
end

Day11.run if __FILE__ == $0

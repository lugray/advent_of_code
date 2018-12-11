#!/usr/bin/env ruby

class Power
  def initialize(serial_number)
    @serial_number = serial_number
    @power_level = Array.new(301) { Array.new(301) { Array.new(301) } }
  end

  def best_power(min_s, max_s)
    max = -Float::INFINITY
    loc = nil
    (min_s..max_s).each do |s|
      (1..301-s).each do |x|
        (1..301-s).each do |y|
          g = power_level(x,y,s)
          if g > max
            max = g
            loc = [x, y, s]
          end
        end
      end
    end
    loc.join(',')
  end

  def power_level(x, y, s = 3)
    @power_level[x][y][s] ||= unmemo_power_level(x, y, s)
  end

  private

  def unmemo_power_level(x, y, s)
    if s == 0
      0
    elsif s == 1
      ((x + 10) * y + @serial_number) * (x + 10) / 100 % 10 - 5
    else
      power_level(x,y,s-1) + power_level(x+1,y+1,s-1) + power_level(x, y+s-1, 1) + power_level(x+s-1, y, 1) - power_level(x+1,y+1,s-2)
    end
  end
end

p = Power.new(1308)
puts p.best_power(3,3)
puts p.best_power(1,300)

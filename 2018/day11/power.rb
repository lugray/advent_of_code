#!/usr/bin/env ruby

class Power
  def initialize(serial_number)
    @serial_number = serial_number
    @power_level = Array.new(301) { Array.new(301) }
    populate_grid
  end

  def populate_grid
    (1..300).each do |x|
      (1..300).each do |y|
        @power_level[x][y] = ((x + 10) * y + @serial_number) * (x + 10) / 100 % 10 - 5
      end
    end
  end

  def best_any_square_power
    max = -Float::INFINITY
    loc = nil
    (1..300).each do |x|
      (1..300).each do |y|
        max_s = 301 - [x, y].max
        square = 0
        (1..max_s).each do |s|
          square += (0...s).inject(0) { |m, dx| m + @power_level[x+dx][y+s-1] }
          square += (0...s-1).inject(0) { |m, dy| m + @power_level[x+s-1][y+dy] }
          if square > max
            max = square
            loc = [x, y, s]
          end
        end
      end
    end
    loc.join(',')
  end

  def best_power
    max = -Float::INFINITY
    loc = nil
    (1..298).each do |x|
      (1..298).each do |y|
        g = grid_power_level(x,y)
        if g > max
          max = g
          loc = [x, y]
        end
      end
    end
    loc.join(',')
  end

  def grid_power_level(x, y, s = 3)
    (0...s).flat_map do |dx|
      (0...s).map do |dy|
        @power_level[x + dx][y + dy]
      end
    end.sum
  end
end

p = Power.new(1308)
puts p.best_power
puts p.best_any_square_power

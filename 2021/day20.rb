#!/usr/bin/env ruby

require_relative 'day'

class Day20 < Day
  def initialize
    enhance, image = input.split("\n\n")
    @enhance = enhance.chomp.each_char.map { |c| c == '#' ? 1 : 0 }
    @image = image.each_line.map do |line|
      line.chomp.each_char.map { |c| c == '#' ? 1 : 0 }
    end
  end

  def pixel(image, parity, x, y)
    return parity unless (0...image.size).include?(y)
    return parity unless (0...image.first.size).include?(x)
    image[y][x]
  end

  def index(image, parity, x, y)
    (y-1..y+1).map do |iy|
      (x-1..x+1).flat_map do |ix|
        pixel(image, parity, ix, iy)
      end
    end.join.to_i(2)
  end

  def enhance(image, parity)
    (-1...image.size+1).map do |y|
      (-1...image.first.size+1).map do |x|
        @enhance[index(image, parity, x, y)]
      end
    end
  end

  def display(image)
    puts (image.map do |row|
      row.map { |n| n == 1 ? '#' : '.' }.join
    end.join("\n")+"\n\n")
  end

  def part_1
    enhance(enhance(@image, 0), 1).flatten.count { |n| n == 1 }
  end

  def part_2
    image = @image
    25.times { image = enhance(enhance(image, 0), 1) }
    image.flatten.count { |n| n == 1 }
  end
end

Day20.run if __FILE__ == $0

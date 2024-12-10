#!/usr/bin/env ruby

require_relative 'day'

class Day10 < Day
  def initialize
    @map = {}
    input_lines.each_with_index do |line, row|
      line.each_char.each_with_index do |char, col|
        @map[[row, col]] = char.to_i
      end
    end
    @reaches = Hash.new { |h, k| h[k] = [] }
    @rating = Hash.new { |h, k| h[k] = [] }
    count!
  end

  def neighbors(pos)
    r, c = pos
    [[r - 1, c], [r + 1, c], [r, c - 1], [r, c + 1]]
  end

  def count!
    @map.each do |pos, value|
      next unless value == 9
      neighbors(pos).each do |neighbor|
        next unless @map[neighbor] == 8
        @reaches[neighbor] << pos unless @reaches[neighbor].include?(pos)
        @rating[neighbor] << pos
      end
    end
    (8.downto(1)).each do |value|
      @map.each do |pos, v|
        next unless v == value
        neighbors(pos).each do |neighbor|
          next unless @map[neighbor] == value - 1
          @reaches[neighbor] += @reaches[pos]
          @reaches[neighbor].uniq!
          @rating[neighbor] += @rating[pos]
        end
      end
    end
  end

  def part_1
    @reaches.sum do |pos, reach|
      next 0 unless @map[pos] == 0
      reach.size
    end
  end

  def part_2
    @rating.sum do |pos, rating|
      next 0 unless @map[pos] == 0
      rating.size
    end
  end
end

Day10.run if __FILE__ == $0

#!/usr/bin/env ruby

require_relative 'day'
require 'set'

class Day18 < Day
  def initialize
    @size, @count = ARGV.include?('--example') ? [6, 12] : [70, 1024]
    @corrupted = input_lines.each_with_index.each_with_object(Hash.new(Float::INFINITY)) do |(line, i), h|
      h[line.split(',').map(&:to_i)] = i + 1
    end
  end

  def neighbors(x, y, corruption_count:)
    [[x-1, y], [x+1, y], [x, y-1], [x, y+1]].select do |nx, ny|
      nx.between?(0, @size) && ny.between?(0, @size) && @corrupted[[nx, ny]] > corruption_count
    end
  end

  def min_steps(corruption_count: @count)
    candidates = Set.new([[0, 0]])
    map = Hash.new { |h, k| h[k] = Float::INFINITY }
    map[[0, 0]] = 0
    loop do
      x, y = candidates.min_by { |x, y| map[[x, y]] }
      return nil if x.nil?
      break if [x, y] == [@size, @size]
      candidates.delete([x, y])
      neighbors(x, y, corruption_count:).each do |nx, ny|
        if map[[nx, ny]] > map[[x, y]] + 1
          map[[nx, ny]] = map[[x, y]] + 1
          candidates << [nx, ny]
        end
      end
    end
    map[[@size, @size]]
  end

  def part_1
    min_steps
  end

  def part_2
    min = @count
    max = @corrupted.size
    while max - min > 1
      candidate = (min + max) / 2
      min_steps(corruption_count: candidate) ? min = candidate : max = candidate
    end
    @corrupted.find { |_, v| v == max }.first.join(',')
  end
end

Day18.run if __FILE__ == $0

#!/usr/bin/env ruby

class Lumber
  def initialize(input)
    @map = input.each_line.map do |line|
      [nil] + line.chomp.each_char.to_a + [nil]
    end
    @map = [Array.new(@map.first.length)] + @map + [Array.new(@map.first.length)]
    @seen = []
  end

  def counts
    zeroes = {'#' => 0, '|' => 0, '.' => 0}
    (1..@map.length-2).map do |row|
      (1..@map.first.length-2).map do |col|
        surrounding = @map[row-1][col-1..col+1] + [@map[row][col-1], @map[row][col+1]] + @map[row+1][col-1..col+1]
        zeroes.merge(surrounding.group_by(&:itself).transform_values(&:length))
      end
    end
  end

  def to_s
    (1..@map.length-2).map do |row|
      (1..@map.first.length-2).map do |col|
        @map[row][col]
      end.join
    end.join("\n")
  end

  def resource_value
    cs = @map.flatten.group_by(&:itself).transform_values(&:length)
    cs['#'] * cs['|']
  end

  def next_map(n = 1, optimize: true)
    n.times do |i|
      @seen << @map.map(&:dup) if optimize
      counts.each_with_index do |cr, row|
        cr.each_with_index do |cs, col|
          case @map[row+1][col+1]
          when '.'
            @map[row+1][col+1] = '|' if cs['|'] >= 3
          when '|'
            @map[row+1][col+1] = '#' if cs['#'] >= 3
          when '#'
            @map[row+1][col+1] = '.' unless cs['#'] >= 1 && cs['|'] >= 1
          end
        end
      end
      if found = @seen.each_with_index.find { |m, i| @map == m }
        cycle_size = i - found[1] + 1
        remain = n - i
        @map = @seen[found[1] + (remain % cycle_size) - 1]
        return self
      end
    end
    self
  end
end

input = '.#.#...|#.
.....#|##|
.|..|...#.
..|#.....#
#.#|||#|#|
...#.||...
.|....|...
||...#|.#|
|.||||..|.
...#.|..|.
'
require 'byebug'
input = File.read('input')
puts Lumber.new(input).next_map(10).resource_value
puts Lumber.new(input).next_map(1000000000).resource_value

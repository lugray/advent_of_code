#!/usr/bin/env ruby

require_relative 'day'

class Tile
  attr_reader :id

  def initialize(str)
    raise 'wut' unless str.start_with?('Tile ')
    n, pixels = str[5..].split(":\n")
    @id = n.to_i
    @pixels = pixels.each_line(chomp: true).map { |l| l.each_char.map { |c| c == '#' } }
  end

  def border_ids
    [top, bottom, left, right]
  end

  def border_id(arr)
    [
      arr.each_with_index.sum { |v, i| v ? 2**i : 0 },
      arr.reverse.each_with_index.sum { |v, i| v ? 2**i : 0 },
    ].min
  end

  def top
    border_id(@pixels.first)
  end

  def bottom
    border_id(@pixels.last)
  end

  def left
    border_id(@pixels.map(&:first))
  end

  def right
    border_id(@pixels.map(&:last))
  end
end

class Day20 < Day
  def initialize
    @tiles = input.split("\n\n").map { |t| Tile.new(t) }
  end

  def part_1
    outer_border_ids = @tiles.flat_map(&:border_ids).sort.chunk(&:itself).map(&:last).select { |a| a.size == 1}.map(&:first)
    @tiles.select do |tile|
      (tile.border_ids & outer_border_ids).size == 2
    end.map(&:id).inject(&:*)
  end

  def part_2
  end
end

Day20.run if __FILE__ == $0

#!/usr/bin/env ruby

require_relative 'day'

class Tree
  attr_reader :height, :visible, :scenic

  def initialize(height)
    @height = (height)
    @visible = false
    @scenic = 1
  end

  def sightline(n)
    @scenic *= n
  end

  def sight!
    @visible = true
  end
end

class Day08 < Day
  def initialize
    @forest = input_lines.map { |l| l.chars.map { |c| Tree.new(c.to_i) } }
  end

  def sight_left(forest)
    forest.each do |row|
      max = -1
      row.each do |tree|
        if tree.height > max
          tree.sight!
          max = tree.height
        end
      end
    end
  end

  def sight_perimeter(forest)
    sight_left(forest)
    sight_left(forest.map(&:reverse))
    sight_left(forest.transpose)
    sight_left(forest.transpose.map(&:reverse))
  end

  def forest?(i, j)
    i >= 0 && i < @forest.size && j >= 0 && j < @forest[i].size
  end

  def tree_at(i, j)
    return nil unless forest?(i, j)
    @forest[i][j]
  end

  def sightline(i, j, di, dj)
    start_height = @forest[i][j].height
    count = 0
    while tree = tree_at(i += di, j += dj)
      count += 1
      break if tree.height >= start_height
    end
    count
  end

  def part_1
    sight_perimeter(@forest)
    @forest.flatten.count(&:visible)
  end

  def part_2
    @forest.each_with_index do |row, i|
      row.each_with_index do |tree, j|
        tree.sightline(sightline(i, j, -1, 0))
        tree.sightline(sightline(i, j, 1, 0))
        tree.sightline(sightline(i, j, 0, -1))
        tree.sightline(sightline(i, j, 0, 1))
      end
    end
    @forest.flatten.max_by(&:scenic).scenic
  end
end

Day08.run if __FILE__ == $0

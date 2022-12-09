#!/usr/bin/env ruby

require_relative 'day'

module Enumerable
  def take_until
    each_with_object([]) do |e, collect|
      collect << e
      break collect if yield(e)
    end
  end
end

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
    @forest = input_lines { |l| l.chars.map { |c| Tree.new(c.to_i) } }
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

  def each_tree(i, j, di, dj)
    return enum_for(:each_tree, i, j, di, dj) unless block_given?
    while tree = tree_at(i += di, j += dj)
      yield(tree)
    end
  end

  def sightline(i, j, di, dj)
    start_height = @forest[i][j].height
    each_tree(i, j, di, dj).take_until { |t| t.height >= start_height }.size
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

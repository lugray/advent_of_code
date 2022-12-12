#!/usr/bin/env ruby

require_relative 'day'
require_relative '../dijkstra'
require 'matrix'

class Day12 < Day
  def initialize
    @elevations = input_lines { |l| l.chars.map(&:ord) }
    @start = Matrix[*@elevations].index('S'.ord)
    @target = Matrix[*@elevations].index('E'.ord)
    @elevations[@start.first][@start.last] = 'a'.ord
    @elevations[@target.first][@target.last] = 'z'.ord
    @height = @elevations.size
    @width = @elevations.first.size
    @graph = Graph.new
    each_neighbour_pair do |a, b|
      add_edge(*a, *b)
      add_edge(*b, *a)
    end
    @graph.dijkstra(@target)
  end

  def each_coord
    return enum_for(:each_coord) unless block_given?
    (0...@height).each do |i|
      (0...@width).each do |j|
        yield(i, j)
      end
    end
  end

  def each_neighbour_pair
    each_coord do |i, j|
      yield([i, j], [i, j + 1]) if j < @width - 1
      yield([i, j], [i + 1, j]) if i < @height - 1
    end
  end

  def add_edge(i1, j1, i2, j2)
    return if @elevations[i2][j2] < @elevations[i1][j1] - 1
    @graph.connect_graph([i1, j1], [i2, j2])
  end

  def part_1
    @graph.distance[@start]
  end

  def part_2
    each_coord.filter_map do |i, j|
      next unless @elevations[i][j] == 'a'.ord
      @graph.distance[[i, j]]
    end.min
  end
end

Day12.run if __FILE__ == $0

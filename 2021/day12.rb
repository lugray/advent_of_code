#!/usr/bin/env ruby

require_relative 'day'

class Day12 < Day
  def initialize
    @connections = input_lines.each_with_object({}) do |line, h|
      a, b = line.split('-')
      h[a] ||= []
      h[b] ||= []
      h[a] << b
      h[b] << a
    end
  end

  def count_paths(node = 'start', small_visited = [], allow_revisit: false)
    return 1 if node == 'end'
    small_visited = small_visited + [node] if node.downcase == node
    @connections[node].sum do |n|
      if (!allow_revisit && small_visited.include?(n)) || n == 'start'
        0
      else
        count_paths(n, small_visited, allow_revisit: allow_revisit && !small_visited.include?(n))
      end
    end
  end

  def part_1
    count_paths
  end

  def part_2
    count_paths(allow_revisit: true)
  end
end

Day12.run if __FILE__ == $0

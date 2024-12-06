#!/usr/bin/env ruby

require_relative 'day'

class Day06 < Day
  UP = 0
  RIGHT = 1
  DOWN = 2
  LEFT = 3
  DIRS = [[-1, 0], [0, 1], [1, 0], [0, -1]]

  def initialize
    @obstacles = {}
    @visited = {}
    @guard = nil
    @facing = UP
    input_lines.each_with_index do |line, i|
      line.each_char.each_with_index do |c, j|
        @visited[[i, j]] = false
        case c
        when '#'
          @obstacles[[i, j]] = true
        when '^'
          @guard = [i, j]
          @visited[@guard] = UP
        end
      end
    end
  end

  def tour(obstacles, visited, guard, facing)
    until visited[guard].nil?
      while !obstacles[[guard[0] + DIRS[facing][0], guard[1] + DIRS[facing][1]]]
        guard[0] += DIRS[facing][0]
        guard[1] += DIRS[facing][1]
        break if visited[guard].nil?
        return true if visited[guard] == facing
        visited[guard] = facing
      end
      facing = (facing + 1) % 4
    end
    false
  end

  def part_1
    tour(@obstacles.dup, visited = @visited.dup, @guard.dup, @facing.dup)
    @p1_visited = visited
    visited.values.count(&:itself)
  end

  def part_2
    @p1_visited.count do |(i, j), v|
      next false if !v || @obstacles[[i, j]] || @guard == [i, j]
      obstacles = @obstacles.dup
      obstacles[[i, j]] = true
      tour(obstacles, @visited.dup, @guard.dup, @facing.dup)
    end
  end
end

Day06.run if __FILE__ == $0

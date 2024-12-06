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

  def tour(obstacles, visited, guard, facing, try_obstacles = false)
    loop_count = 0
    until visited[guard].nil?
      while !obstacles[[guard[0] + DIRS[facing][0], guard[1] + DIRS[facing][1]]]
        if try_obstacles
          new_obstacles = obstacles.dup
          new_obstacles[[guard[0] + DIRS[facing][0], guard[1] + DIRS[facing][1]]] = true
          looping, _ = tour(new_obstacles, visited.dup, guard.dup, facing.dup, false)
          loop_count += 1 if looping
        end
        guard[0] += DIRS[facing][0]
        guard[1] += DIRS[facing][1]
        break if visited[guard].nil?
        return [true, loop_count] if visited[guard] == facing
        visited[guard] = facing
      end
      facing = (facing + 1) % 4
    end
    return [false, loop_count]
  end

  def part_1
    tour(@obstacles.dup, visited = @visited.dup, @guard.dup, @facing.dup)
    visited.values.count(&:itself)
  end

  def part_2
    _, loop_count = tour(@obstacles.dup, visited = @visited.dup, @guard.dup, @facing.dup, true)
    loop_count
  end
end

Day06.run if __FILE__ == $0

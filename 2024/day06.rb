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
        end
      end
    end
  end

  def next_straight(guard, facing)
    [guard[0] + DIRS[facing][0], guard[1] + DIRS[facing][1]]
  end

  def looping?(obstacles, visited, guard, facing)
    until visited[guard] == facing || visited[guard].nil?
      visited[guard] = facing
      facing = (facing + 1) % 4 while obstacles[next_straight(guard, facing)]
      guard = next_straight(guard, facing)
    end
    visited[guard] == facing
  end

  def loop_count(obstacles, visited, guard, facing)
    loop_count = 0
    until visited[guard] == facing || visited[guard].nil?
      facing = (facing + 1) % 4 while obstacles[next_straight(guard, facing)]
      if visited[next_straight(guard, facing)] == false
        new_obstacles = obstacles.dup.tap { |h| h[next_straight(guard, facing)] = true }
        loop_count += 1 if looping?(new_obstacles, visited.dup, guard.dup, facing.dup)
      end
      visited[guard] = facing
      guard = next_straight(guard, facing)
    end
    loop_count
  end

  def part_1
    looping?(@obstacles.dup, visited = @visited.dup, @guard.dup, @facing.dup)
    visited.values.count(&:itself)
  end

  def part_2
    loop_count(@obstacles.dup, visited = @visited.dup, @guard.dup, @facing.dup)
  end
end

Day06.run if __FILE__ == $0

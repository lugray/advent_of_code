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
    @facing = UP
    input_lines.each_with_index do |line, i|
      line.each_char.each_with_index do |c, j|
        @visited[[i, j]] = false
        case c
        when '#' then @obstacles[[i, j]] = true
        when '^' then @guard = [i, j]
        end
      end
    end
  end

  def next_straight(guard, facing) = [guard[0] + DIRS[facing][0], guard[1] + DIRS[facing][1]]
  def new_obstacle(obstacles, new_pos) = obstacles.dup.tap { |h| h[new_pos] = true }

  def loop_count(obstacles, visited, guard, facing, add_obstacles = false)
    lc = 0
    loop do
      visited[guard] = facing
      facing = (facing + 1) % 4 while obstacles[next_straight(guard, facing)]
      if add_obstacles && visited[next_straight(guard, facing)] == false
        lc += loop_count(new_obstacle(obstacles, next_straight(guard, facing)), visited.dup, guard, facing, false)
      end
      guard = next_straight(guard, facing)
      break if visited[guard] == facing || visited[guard].nil?
    end
    lc + (visited[guard] == facing ? 1 : 0)
  end

  def part_1
    loop_count(@obstacles, visited = @visited.dup, @guard, @facing)
    visited.values.count(&:itself)
  end

  def part_2
    loop_count(@obstacles, @visited.dup, @guard, @facing, true)
  end
end

Day06.run if __FILE__ == $0

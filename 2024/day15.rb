#!/usr/bin/env ruby

require_relative 'day'
require 'matrix'

class Day15 < Day
  WALL = '#'
  OPEN = '.'
  BOX = 'O'
  ROBOT = '@'
  BOX1 = '['
  BOX2 = ']'
  LEFT = Vector[0, -1]
  RIGHT = Vector[0, 1]
  UP = Vector[-1, 0]
  DOWN = Vector[1, 0]

  def initialize
  end

  def part_1
    map = {}
    robot = nil
    m, i= input_paragraphs
    instructions = i.each_line(chomp: true).to_a.join
    m.each_line.each_with_index do |line, row|
      line.each_char.each_with_index do |char, col|
        if char == ROBOT
          robot = [row, col]
          char = OPEN
        end
        map[[row, col]] = char
      end
    end
    mr = m.each_line.count - 1
    mc = m.each_line.first.length - 1
    instructions.each_char do |instruction|
      case instruction
      when '^'
        open_row = (robot[0]-1).downto(0).find do |row|
          case map[[row, robot[1]]]
          when WALL then break nil
          when BOX then false
          when OPEN then true
          end
        end
        if open_row
          r = robot[0] -= 1
          c = robot[1]
          map[[r, c]], map[[open_row, c]] = map[[open_row, c]], map[[r, c]]
        end
      when 'v'
        open_row = (robot[0]+1).upto(mr).find do |row|
          case map[[row, robot[1]]]
          when WALL then break nil
          when BOX then false
          when OPEN then true
          end
        end
        if open_row
          r = robot[0] += 1
          c = robot[1]
          map[[r, c]], map[[open_row, c]] = map[[open_row, c]], map[[r, c]]
        end
      when '<'
        open_col = (robot[1]-1).downto(0).find do |col|
          case map[[robot[0], col]]
          when WALL then break nil
          when BOX then false
          when OPEN then true
          end
        end
        if open_col
          r = robot[0]
          c = robot[1] -= 1
          map[[r, c]], map[[r, open_col]] = map[[r, open_col]], map[[r, c]]
        end
      when '>'
        open_col = (robot[1]+1).upto(mc).find do |col|
          case map[[robot[0], col]]
          when WALL then break nil
          when BOX then false
          when OPEN then true
          end
        end
        if open_col
          r = robot[0]
          c = robot[1] += 1
          map[[r, c]], map[[r, open_col]] = map[[r, open_col]], map[[r, c]]
        end
      end
    end
    map.sum do |(row, col), char|
      next 0 unless char == BOX
      100 * row + col
    end
  end

  def moves?(map, pos, dir)
    case map[pos + dir]
    when nil then false
    when WALL then false
    when OPEN then true
    when BOX1
      if [UP, DOWN].include?(dir)
        moves?(map, pos + dir, dir) && moves?(map, pos + dir + RIGHT, dir)
      else
        moves?(map, pos + dir, dir)
      end
    when BOX2
      if [UP, DOWN].include?(dir)
        moves?(map, pos + dir, dir) && moves?(map, pos + dir + LEFT, dir)
      else
        moves?(map, pos + dir, dir)
      end
    end
  end

  def move(map, pos, dir)
    if [UP, DOWN].include?(dir)
      case map[pos + dir]
      when BOX1
        move(map, pos + dir, dir)
        move(map, pos + dir + RIGHT, dir)
      when BOX2
        move(map, pos + dir, dir)
        move(map, pos + dir + LEFT, dir)
      end
    else
      if [BOX1, BOX2].include?(map[pos + dir])
        move(map, pos + dir, dir)
      end
    end
    map[pos + dir] = map[pos]
    map[pos] = OPEN
  end

  def draw(map, mr, mc)
    puts ((0..mr).map do |row|
      (0..mc).map do |col|
        map[Vector[row, col]]
      end.join
    end.join("\n"))
  end

  def part_2
    map = {}
    robot = nil
    m, i= input_paragraphs
    instructions = i.each_line(chomp: true).to_a.join
    m.each_line.each_with_index do |line, row|
      line.each_char.each_with_index do |char, col|
        case char
        when ROBOT
          robot = Vector[row, col*2]
          map[Vector[row, col*2]] = OPEN
          map[Vector[row, col*2+1]] = OPEN
        when WALL
          map[Vector[row, col*2]] = WALL
          map[Vector[row, col*2+1]] = WALL
        when BOX
          map[Vector[row, col*2]] = BOX1
          map[Vector[row, col*2+1]] = BOX2
        when OPEN
          map[Vector[row, col*2]] = OPEN
          map[Vector[row, col*2+1]] = OPEN
        end
      end
    end
    mr = m.each_line.count - 1
    mc = m.each_line.first.length * 2 - 1
    instructions.each_char do |instruction|
      case instruction
      when '^'
        if moves?(map, robot, UP)
          move(map, robot, UP)
          robot += UP
        end
      when 'v'
        if moves?(map, robot, DOWN)
          move(map, robot, DOWN)
          robot += DOWN
        end
      when '<'
        if moves?(map, robot, LEFT)
          move(map, robot, LEFT)
          robot += LEFT
        end
      when '>'
        if moves?(map, robot, RIGHT)
          move(map, robot, RIGHT)
          robot += RIGHT
        end
      end
    end
    map.sum do |v, char|
      next 0 unless char == BOX1
      100 * v[0] + v[1]
    end
  end
end

Day15.run if __FILE__ == $0

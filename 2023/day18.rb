#!/usr/bin/env ruby

require_relative 'day'

class Day18 < Day
  RIGHT = 0
  DOWN = 1
  LEFT = 2
  UP = 3

  DIR = {
    'U' => [0, 1],
    'R' => [1, 0],
    'D' => [0, -1],
    'L' => [-1, 0],
    '0' => [1, 0],
    '1' => [0, -1],
    '2' => [-1, 0],
    '3' => [0, 1],
  }

  def initialize
    @plan = input_lines
  end

  def plan_1
    return enum_for(:plan_1) unless block_given?
    @plan.each do |line|
      dir, count, _ = line.split(' ')
      yield [DIR[dir], count.to_i]
    end
  end

  def plan_2
    return enum_for(:plan_2) unless block_given?
    @plan.each do |line|
      _, _, code = line.split(' ')
      yield [DIR[code[-2]], code[2...-2].to_i(16)]
    end
  end

  def area(plan)
    x = y = p = a = 0
    plan.each do |(dx, dy), length|
      x += dx * length
      y += dy * length
      p += length
      a += x * dy * length
    end
    a.abs + p/2 + 1
  end

  def part_1
    area(plan_1)
  end

  def part_2
    area(plan_2)
  end
end

Day18.run if __FILE__ == $0

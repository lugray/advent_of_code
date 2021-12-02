#!/usr/bin/env ruby

require_relative 'day'

class Day02 < Day
  def initialize
    @movements = input.each_line.map do |l|
      a, b = l.split(' ')
      [a, b.to_i]
    end
  end

  def part_1
    x = 0
    y = 0
    @movements.each do |dir, d|
      case dir
      when 'forward'
        x += d
      when 'down'
        y += d
      when 'up'
        y -= d
      else
        raise('wut')
      end
    end
    x*y
  end

  def part_2
    x = 0
    y = 0
    aim = 0
    @movements.each do |dir, d|
      case dir
      when 'forward'
        x += d
        y += d * aim
      when 'down'
        aim += d
      when 'up'
        aim -= d
      else
        raise('wut')
      end
    end
    x*y
  end
end

Day02.run if __FILE__ == $0

#!/usr/bin/env ruby

require_relative 'day'
require_relative 'intcode'

class Day17 < Day
  def part_1
    intcode = Intcode.new(input.split(',').map(&:to_i))
    x = 0
    y = 0
    map = {}
    intcode.run.outputs.each do |c|
      case c.chr
      when '#', '<', '>', 'v', '^'
        map[[x, y]] = '#'
      when '.'
        map[[x,y]] = '.'
      when "\n"
        x = -1
        y += 1
      else
        raise 'wut?'
      end
      x += 1
    end
    map.sum do |(x, y), t|
      if t == '#' && map[[x-1, y]] == '#' && map[[x+1, y]] == '#' && map[[x, y-1]] == '#' && map[[x, y+1]] == '#'
        x * y
      else
        0
      end
    end
  end

  def part_2
    # R,8,L,10,R,8,R,12,R,8,L,8,L,12,R,8,L,10,R,8,L,12,L,10,L,8,R,8,L,10,R,8,R,12,R,8,L,8,L,12,L,12,L,10,L,8,L,12,L,10,
    # L,8,R,8,L,10,R,8,R,12,R,8,L,8,L,12
    instructions = [
      "A,B,A,C,A,B,C,C,A,B",
      "R,8,L,10,R,8",
      "R,12,R,8,L,8,L,12",
      "L,12,L,10,L,8",
      "n",
    ]
    intcode = Intcode.new(input.split(',').map(&:to_i)).with(0 => 2)
    instructions.each do |l|
      intcode.with_inputs(*l.each_char.map(&:ord), "\n".ord)
    end
    intcode.run.outputs.last
  end
end

Day17.run if __FILE__ == $0

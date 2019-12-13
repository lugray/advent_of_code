#!/usr/bin/env ruby

require_relative 'day'
require_relative 'intcode'
require 'io/console'

class Day13 < Day
  def part_1
    game = Intcode.new(input.split(',').map(&:to_i))
    game.run.outputs.each_slice(3).count { |_, _, type| type == 2 }
  end

  def part_2
    game = Intcode.new(input.split(',').map(&:to_i)).with(0 => 2)
    score = 0
    ball = 0
    paddle = 0
    loop do
      game.run
      game.outputs.each_slice(3) do |x, y, t|
        if x == -1
          score = t
        elsif t == 4
          ball = x
        elsif t == 3
          paddle = x
        end
      end
      game.outputs.clear
      break if game.done?
      delta = ball - paddle
      if delta.positive?
        game.with_inputs(1)
      elsif delta.negative?
        game.with_inputs(-1)
      else
        game.with_inputs(0)
      end
    end
    score
  end
end

Day13.run if __FILE__ == $0

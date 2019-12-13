#!/usr/bin/env ruby

require_relative 'intcode'

class Day13Vis
  def initialize(input)
    @game = Intcode.new(input.split(',').map(&:to_i)).with(0 => 2)
  end

  def play
    print "\e[2J\e[?25l"
    loop do
      @game.run
      draw
      break if @game.done?
      delta = @ball - @paddle
      if delta.positive?
        @game.with_inputs(1)
      elsif delta.negative?
        @game.with_inputs(-1)
      else
        @game.with_inputs(0)
      end
      sleep(0.005)
    end
  end

  def tile(t)
    case t
    when 0
      ' '
    when 1
      '█'
    when 2
      '■'
    when 3
      '-'
    when 4
      '●'
    end
  end

  def draw
    @game.outputs.each_slice(3) do |x, y, t|
      if x == -1
        print "\e[H"
        print t
      else
        if t == 4
          @ball = x
        elsif t == 3
          @paddle = x
        end
        print "\e[#{y + 2};#{x + 1}H"
        print tile(t)
      end
    end
    STDOUT.flush
    @game.outputs.clear
  end
end

Day13Vis.new(File.read('day13.input')).play

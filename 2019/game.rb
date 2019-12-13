#!/usr/bin/env ruby

require_relative 'intcode'
require 'io/console'

class Game
  def initialize(input)
    @game = Intcode.new(input.split(',').map(&:to_i)).with(0 => 2)
  end

  def play
    print "\e[2J\e[?25l"
    loop do
      @game.run
      draw
      break if @game.done?
      case STDIN.getch
      when 'h'
        @game.with_inputs(-1)
      when 'l'
        @game.with_inputs(1)
      when 'q'
        break
      else
        @game.with_inputs(0)
      end
    end
  end
  
  private

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
        print "\e[#{y + 2};#{x + 1}H"
        print tile(t)
      end
    end
    STDOUT.flush
    @game.outputs.clear
  end
end

Game.new(File.read('day13.input')).play

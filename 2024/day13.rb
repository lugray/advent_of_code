#!/usr/bin/env ruby

require_relative 'day'

class Day13 < Day
  OFFSET = 10000000000000

  def initialize
    @games = input_paragraphs.map { |game| game.scan(/\d+/).map(&:to_i) }
  end

  def cost(ax, ay, bx, by, tx, ty)
    nb = ((tx - ty*ax/ay.to_f) / (bx - by*ax/ay.to_f)).round
    na = ((tx - nb * bx) / ax.to_f).round
    return 0 unless na * ax + nb * bx == tx && na * ay + nb * by == ty
    na * 3 + nb
  end

  def part_1
    @games.sum { |ax, ay, bx, by, tx, ty| cost(ax, ay, bx, by, tx, ty) }
  end

  def part_2
    @games.sum { |ax, ay, bx, by, tx, ty| cost(ax, ay, bx, by, tx + OFFSET, ty + OFFSET) }
  end
end

Day13.run if __FILE__ == $0

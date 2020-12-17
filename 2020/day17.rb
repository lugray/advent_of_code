#!/usr/bin/env ruby

require_relative 'day'

class LifeN
  def initialize(start, n)
    @cells = {}
    start.each_line.each_with_index do |l, y|
      l.chomp.each_char.each_with_index do |c, x|
        if c == '#'
          live([x, y, *Array.new(n-2, 0)])
        end
      end
    end
  end

  def surround(c)
    c.map { |i| (i-1..i+1).to_a }.inject { |a, b| a.product(b) }.map(&:flatten)
  end

  def surround_count(c)
    (surround(c)-[c]).count { |cc| live?(cc) }
  end

  def step
    cells = {}
    @cells.keys.flat_map { |c| surround(c) }.uniq.each do |c|
      if live?(c)
        live(c, cells) if (2..3) === surround_count(c)
      else
        live(c, cells) if 3 == surround_count(c)
      end
    end
    @cells = cells
  end

  def live?(cc)
    @cells.key?(cc)
  end

  def live(cc, cells = @cells)
    cells[cc] = true
  end

  def live_count
    @cells.size
  end
end

class Day17 < Day
  def part_1
    pocket = LifeN.new(input, 3)
    6.times { pocket.step }
    pocket.live_count
  end

  def part_2
    pocket = LifeN.new(input, 4)
    6.times { pocket.step }
    pocket.live_count
  end
end

Day17.run if __FILE__ == $0

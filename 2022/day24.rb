#!/usr/bin/env ruby

require_relative 'day'

class Day24 < Day
  def initialize
    @input = input.each_line(chomp: true).map { |line| line[1..-2].chars }[1..-2]
    @left = @input.map { |line| line.map { |c| c == '<' } }
    @right = @input.map { |line| line.map { |c| c == '>' } }
    @up = @input.map { |line| line.map { |c| c == '^' } }
    @down = @input.map { |line| line.map { |c| c == 'v' } }
    @max_r = @input.size - 1
    @max_c = @input.first.size - 1
    @minute = 0
  end

  def advance_blizzards
    @minute += 1
    @left = @left.map { |line| line.rotate }
    @right = @right.map { |line| line.rotate(-1) }
    @up = @up.rotate
    @down = @down.rotate(-1)
  end

  def at_start?(r, c)
    r == -1 && c == 0
  end

  def at_end?(r, c)
    r == @max_r + 1 && c == @max_c
  end

  def out_of_bounds?(r, c)
    return false if at_start?(r, c)
    return false if at_end?(r, c)
    r < 0 || c < 0 || r > @max_r || c > @max_c
  end

  def blizzard?(r, c)
    return false if at_start?(r, c)
    return false if at_end?(r, c)
    @left[r][c] || @right[r][c] || @up[r][c] || @down[r][c]
  end

  def nexts_from(r, c)
    [
      [r, c],
      [r - 1, c],
      [r + 1, c],
      [r, c - 1],
      [r, c + 1],
    ].reject { |r, c| out_of_bounds?(r, c) || blizzard?(r, c) }
  end

  def part_1
    actors = [[-1, 0]]
    loop do
      advance_blizzards
      actors = actors.map { |r, c| nexts_from(r, c) }.flatten(1).uniq
      break if actors.any? { |r, c| at_end?(r, c) }
    end
    @minute
  end

  def part_2
    actors = [[@max_r + 1, @max_c]]
    loop do
      advance_blizzards
      actors = actors.map { |r, c| nexts_from(r, c) }.flatten(1).uniq
      break if actors.any? { |r, c| at_start?(r, c) }
    end
    part_1
  end
end

Day24.run if __FILE__ == $0

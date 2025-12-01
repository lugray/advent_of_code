#!/usr/bin/env ruby

require_relative 'day'

class Day01 < Day
  def initialize
    @moves = input_lines do |line|
      case line[0]
      when 'L'; line[1..-1].to_i * -1
      when 'R'; line[1..-1].to_i
      else;     raise "Unknown direction #{line[0]}"
      end
    end
  end

  def count_zeros(moves)
    moves.inject([50, 0]) do |(curr, count), move|
      curr = (curr + move) % 100
      [curr, count + (curr == 0 ? 1 : 0)]
    end.last
  end

  def split_moves(moves)
    return enum_for(:split_moves, moves) unless block_given?
    moves.each { |move| move.abs.times { yield move / move.abs } }
  end

  def part_1
    count_zeros(@moves)
  end

  def part_2
    count_zeros(split_moves(@moves))
  end
end

Day01.run if __FILE__ == $0

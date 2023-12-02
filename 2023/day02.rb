#!/usr/bin/env ruby

require_relative 'day'

class Day02 < Day
  def initialize
    @games = input_lines.each_with_object({}) do |line, games|
      label, rounds = line.split(': ')
      id = label.split(' ').last.to_i
      games[id] = rounds.split('; ').map do |round|
        round.split(', ').each_with_object(Hash.new(0)) do |cc, counts|
          count, color = cc.split(' ')
          counts[color] = count.to_i
        end
      end
    end
  end

  def part_1
    @games.sum do |id, rounds|
      rounds.any? { |r| r["red"] > 12 || r["green"] > 13 || r["blue"] > 14 } ? 0 : id
    end
  end

  def part_2
    @games.values.sum do |rounds|
      {}.merge(*rounds) { |_, c1, c2| [c1, c2].max }.values.inject(:*)
    end
  end
end

Day02.run if __FILE__ == $0

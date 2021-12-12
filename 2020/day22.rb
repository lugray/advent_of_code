#!/usr/bin/env ruby

require_relative 'day'

class Day22 < Day
  def input
    return super
    <<~INPUT
      Player 1:
      9
      2
      6
      3
      1

      Player 2:
      5
      8
      4
      7
      10
    INPUT
  end
  def initialize
    @decks = input.split("\n\n").map do |deck|
      deck.each_line(chomp: true).to_a[1..].map(&:to_i)
    end
  end

  def part_1
    decks = @decks.map(&:dup)
    until decks.any?(&:empty?) do
      cards = decks.map(&:shift)
      if cards.first > cards.last
        decks.first.push(cards.first)
        decks.first.push(cards.last)
      else
        decks.last.push(cards.last)
        decks.last.push(cards.first)
      end
    end
    decks.reject(&:empty?).first.reverse.zip(1..).map{ |a, b| a * b }.sum
  end

  def part_2
  end
end

Day22.run if __FILE__ == $0

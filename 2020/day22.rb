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

  def recursive_combat(decks)
    seen = Set.new
    until decks.any?(&:empty?) do
      if seen.include?(decks)
        return 0
      end
      seen << decks.map(&:dup)
      cards = decks.map(&:shift)
      if cards.zip(decks).all? { |card, deck| deck.size >= card }
        inner_decks = cards.zip(decks).map { |card, deck| deck[0...card] }
        winner = recursive_combat(inner_decks)
      else
        winner = cards.index(cards.max)
      end
      cards.reverse! if winner == 1
      decks[winner].push(cards.first)
      decks[winner].push(cards.last)
    end
    decks.index { |deck| !deck.empty? }
  end
  
  def score(decks)
    decks.reject(&:empty?).first.reverse.zip(1..).map{ |a, b| a * b }.sum
  end

  def combat(decks)
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
  end

  def part_1
    decks = @decks.map(&:dup)
    combat(decks)
    score(decks)
  end

  def part_2
    decks = @decks.map(&:dup)
    recursive_combat(decks)
    score(decks)
  end
end

Day22.run if __FILE__ == $0

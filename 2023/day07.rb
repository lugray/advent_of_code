#!/usr/bin/env ruby

require_relative 'day'

class Day07 < Day
  JOKER = 0
  CARD_VALUES = { 'A' => 14, 'K' => 13, 'Q' => 12, 'J' => 11, 'T' => 10 }.tap { |h| h.default_proc = ->(_, k) { k.to_i } }
  CARD_VALUES_WITH_JOKER = CARD_VALUES.merge('J' => JOKER)

  class Hand
    TYPE_ORDER = [
      [1, 1, 1, 1, 1], # High Card
      [1, 1, 1, 2], # Pair
      [1, 2, 2], # Two Pair
      [1, 1, 3], # Three of a Kind
      [2, 3], # Full House
      [1, 4], # Four of a Kind
      [5] # Five of a Kind
    ]

    attr_reader :cards, :bid

    def initialize(cards, bid)
      @cards = cards
      @bid = bid
    end

    def type_value
      cards = @cards.reject { |c| c == JOKER }
      cards += Array.new(5 - cards.size, cards.tally.max_by(&:last)&.first || 14)
      TYPE_ORDER.index(cards.tally.values.sort)
    end

    def <=>(other)
      (type_value <=> other.type_value).nonzero? || @cards <=> other.cards
    end
  end

  def parse_hands(transformation_hash)
    input_grid.map do |cards, bid|
      Hand.new(cards.each_char.map { |c| transformation_hash[c] }, bid.to_i)
    end
  end

  def winnings(transformation_hash)
    parse_hands(transformation_hash).sort.each_with_index.sum { |hand, i| hand.bid * (i + 1) }
  end

  def part_1
    winnings(CARD_VALUES)
  end

  def part_2
    winnings(CARD_VALUES_WITH_JOKER)
  end
end

Day07.run if __FILE__ == $0

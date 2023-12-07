#!/usr/bin/env ruby

require_relative 'day'

class Day07 < Day
  class Hand
    attr_reader :cards, :bid

    def initialize(cards, bid)
      @cards = cards
      @bid = bid
    end

    def transform_jokers
      return unless @cards.include?(11)
      original_cards = @cards.dup
      @cards.reject! { |c| c == 11 }
      best_card = @cards.tally.max_by { |_, v| v }&.first || 14
      while @cards.size < 5
        @cards << best_card
      end
      @sorted_tally = nil
      @type_value = nil
      type_value
      @cards = original_cards.map { |c| c == 11 ? 1 : c }
    end

    def sorted_tally
      @sorted_tally ||= @cards.tally.values.sort
    end

    def five_of_a_kind? = sorted_tally == [5]
    def four_of_a_kind? = sorted_tally == [1, 4]
    def full_house? = sorted_tally == [2, 3]
    def three_of_a_kind? = sorted_tally == [1, 1, 3]
    def two_pair? = sorted_tally == [1, 2, 2]
    def pair? = sorted_tally == [1, 1, 1, 2]

    def type_value
      @type_value ||= case
      when five_of_a_kind? then 6
      when four_of_a_kind? then 5
      when full_house? then 4
      when three_of_a_kind? then 3
      when two_pair? then 2
      when pair? then 1
      else 0
      end
    end

    def <=>(other)
      (type_value <=> other.type_value).nonzero? || @cards <=> other.cards
    end

    def to_s
      @cards.map { |c| CARD_VALUES.key(c) || c.to_s }.join
    end
  end

  CARD_VALUES = { 'A' => 14, 'K' => 13, 'Q' => 12, 'J' => 11, 'T' => 10 }.tap { |h| h.default_proc = ->(_, k) { k.to_i } }

  def initialize
    @hands = input_lines do |line|
      cards, bid = line.split(' ')
      Hand.new(cards.each_char.map { |c| CARD_VALUES[c] }, bid.to_i)
    end
  end

  def part_1
    @hands.sort.each_with_index.sum { |hand, i| hand.bid * (i + 1) }
  end

  def part_2
    @hands.each(&:transform_jokers)
    @hands.sort.each_with_index.sum { |hand, i| hand.bid * (i + 1) }
  end
end

Day07.run if __FILE__ == $0

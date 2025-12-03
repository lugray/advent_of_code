#!/usr/bin/env ruby

require_relative 'day'

class Day03 < Day
  def initialize
    @banks = input_lines.map { |l| l.each_char.map(&:to_i) }
  end

  def bank_max(bank, batteries)
    return "" if batteries == 0
    max, i = bank[..-batteries].each_with_index.max_by(&:first)
    (max.to_s + bank_max(bank[i+1..], batteries - 1).to_s).to_i
  end

  def part_1
    @banks.sum { |bank| bank_max(bank, 2) }
  end

  def part_2
    @banks.sum { |bank| bank_max(bank, 12) }
  end
end

Day03.run if __FILE__ == $0

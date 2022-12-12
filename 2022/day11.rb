#!/usr/bin/env ruby

require_relative 'day'

class Monkey
  @all = []

  class << self
    attr_reader :all

    def round(mod_worry: nil)
      all.each { |monkey| monkey.turn(mod_worry:) }
    end

    def clear!
      @all = []
    end
  end

  attr_reader :inspect_count, :modulo

  def initialize(name:, items:, inspect_proc:, modulo:, true_case:, false_case:)
    @name = name
    @items = items
    @inspect_proc = inspect_proc
    @modulo = modulo
    @true_case = true_case
    @false_case = false_case
    @inspect_count = 0
    Monkey.all << self
  end

  def turn(mod_worry:)
    while item = @items.shift
      process(item, mod_worry:)
    end
  end

  def process(item, mod_worry:)
    @inspect_count += 1
    item = @inspect_proc.call(item)
    if mod_worry
      item = item % mod_worry
    else
      item = item / 3
    end
    Monkey.all[test_case(item) ? @true_case : @false_case].push(item)
  end

  def push(item)
    @items << item
  end

  def test_case(item)
    item % @modulo == 0
  end
end

class Day11 < Day
  def initialize
    Monkey.clear!
    @monkeys = input.split("\n\n").map do |monkey_data|
      name, item, operation, test, true_case, false_case = monkey_data.lines(chomp: true)
      _, item = item.split(': ')
      items = item.split(', ').map(&:to_i)
      _, inspect_string = operation.split('new = ')
      inspect_proc = Proc.new { |old| eval(inspect_string) }
      _, modulo = test.split('divisible by ')
      modulo = modulo.to_i
      _, true_case = true_case.split('to monkey ')
      true_case = true_case.to_i
      _, false_case = false_case.split('to monkey ')
      false_case = false_case.to_i
      Monkey.new(name:, items:, inspect_proc:, modulo:, true_case:, false_case:)
    end
  end

  def part_1
    20.times { Monkey.round }
    Monkey.all.map(&:inspect_count).max(2).inject(:*)
  end

  def part_2
    initialize
    10000.times { Monkey.round(mod_worry: Monkey.all.map(&:modulo).inject(&:*)) }
    Monkey.all.map(&:inspect_count).max(2).inject(:*)
  end
end

Day11.run if __FILE__ == $0

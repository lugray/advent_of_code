#!/usr/bin/env ruby

require_relative 'day'

class Chemical
  def initialize(recipe)
    input, output = recipe.split(' => ')
    @parts = input.split(', ').map do |part|
      q, name = part.split(' ')
      [q.to_i, name]
    end
    q, @name = output.split(' ')
    @quantity = q.to_i
    @on_hand = 0
  end

  def ore_to_make(n, chemicals)
    if @on_hand >= n
      @on_hand -= n
      return 0
    elsif @on_hand > 0
      n -= @on_hand
      @on_hand = 0
    end

    recipe_count = (n / @quantity.to_f).ceil 
    @on_hand += recipe_count * @quantity - n
    @parts.map { |q, name| chemicals[name].ore_to_make(q * recipe_count, chemicals) }.sum
  end
end

class Ore
  def ore_to_make(n, _)
    n
  end
end

class Day14 < Day
  def initialize
    @chemicals = input.each_line.map { |l| [l.chomp.split(' ').last, Chemical.new(l.chomp)] }.to_h
    @chemicals['ORE'] = Ore.new
  end

  def part_1
    @chemicals['FUEL'].ore_to_make(1, @chemicals)
  end

  def part_2
    remain = 1000000000000
    initialize
    max_ore_per_fuel = part_1
    initialize
    f = 0
    loop do
      q = [remain / max_ore_per_fuel, 1].max
      remain -= @chemicals['FUEL'].ore_to_make(q, @chemicals)
      if remain < 0
        return f
      end
      f += q
    end
  end
end

Day14.run if __FILE__ == $0

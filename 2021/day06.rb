#!/usr/bin/env ruby

require_relative 'day'

class Day06 < Day
  def initialize
    @fish = input.split(',').map(&:to_i).tally
  end

  def next_gen
    @fish = @fish.transform_keys { |age, _count| age - 1 }
    if @fish[-1]
      @fish[8] = @fish[-1]
      @fish[6] = @fish.fetch(6, 0) + @fish[-1]
      @fish.delete(-1)
    end
  end

  def part_1
    80.times { next_gen }
    @fish.sum { |_timer, count| count }
  end

  def part_2
    initialize
    256.times { next_gen }
    @fish.sum { |_timer, count| count }
  end
end

Day06.run if __FILE__ == $0

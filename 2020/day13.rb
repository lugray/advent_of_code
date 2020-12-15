#!/usr/bin/env ruby

require_relative 'day'
require 'prime'

class Day13 < Day
  def initialize
    l1, l2 = input.each_line.map(&:chomp)
    @target = l1.to_i
    @ids = l2.split(',').map(&:to_i)
  end

  def part_1
    id = @ids.reject(&:zero?).min_by { |id| time_of(id) }
    (time_of(id) - @target) * id
  end

  def part_2
    raise "Not all prime." unless @ids.reject(&:zero?).all?(&:prime?)
    targets = @ids.each_with_index.reject { |n, _| n.zero? }.map { |n, i| [n, (n - i) % n] }
    n, a = targets.shift
    x = nil
    while target = targets.shift
      n2, a2 = target
      (0..).find do |i|
        x = a + n * i
        x % n2 == a2
      end
      n = n * n2
      a = x
    end
    x
  end

  def time_of(id)
    (@target.to_f / id).ceil * id
  end
end

Day13.run if __FILE__ == $0

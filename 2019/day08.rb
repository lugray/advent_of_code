#!/usr/bin/env ruby

require_relative 'day'

class Day08 < Day
  W = 25
  H = 6

  def part_1
    layer = layers.min_by { |layer| layer.count { |p| p.zero? } }
    layer.count { |p| p == 1 } * layer.count { |p| p == 2 }
  end

  def part_2
    layers.inject do |l1, l2|
      l1.zip(l2).map do |p1, p2|
        p1 == 2 ? p2 : p1
      end
    end.map { |p| p == 1 ? '*' : ' ' }.each_slice(W).map(&:join).join("\n")
  end

  def layers
    input.chomp.each_char.map(&:to_i).each_slice(W*H)
  end
end

Day08.run if __FILE__ == $0

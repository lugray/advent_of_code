#!/usr/bin/env ruby

require_relative 'day'

class Day16 < Day
  PATTERN = [0, 1, 0, -1]

  def iterate
    @list = (1..@list.count+1).map do |i|
      pattern = PATTERN.flat_map { |v| i.times.map { v } }
      pattern.push(pattern.shift)
      @list.zip(pattern.cycle).sum do |a, b|
        a * b
      end.abs.modulo(10)
    end
  end

  def part_1
    @list = input.chomp.each_char.map(&:to_i)
    100.times { iterate }
    @list.take(8).join
  end

  def fast_iterate
    (@list.count - 1).downto(@offset).each do |i|
      @list[i] = @list[i..i+1].sum.modulo(10)
    end
  end

  def part_2
    @list = input.chomp.each_char.map(&:to_i) * 10000
    @offset = @list.take(7).join.to_i
    raise 'Unmet assumption' unless @offset > @list.count / 2
    100.times { fast_iterate }
    @list[@offset...@offset+8].join
  end
end

Day16.run if __FILE__ == $0

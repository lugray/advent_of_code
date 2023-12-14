#!/usr/bin/env ruby

require_relative 'day'

class Day13 < Day
  def initialize
    @regions = input_paragraphs.map do |paragraph|
      paragraph.each_line(chomp: true).map do |line|
        line.each_char.map { |c| c == '#' }
      end
    end
  end

  def mirror_row(region, corrections)
    (1..region.size-1).find do |i|
      (i-1).downto([0, 2 * i - region.size].max).zip(i..region.size-1).sum do |j, k|
        region[j].zip(region[k]).count { |a, b| a != b }
      end == corrections
    end || 0
  end

  def summary(corrections = 0)
    @regions.map do |region|
      100 * mirror_row(region, corrections) + mirror_row(region.transpose, corrections)
    end.sum
  end

  def part_1
    summary
  end

  def part_2
    summary(1)
  end
end

Day13.run if __FILE__ == $0

#!/usr/bin/env ruby

require_relative 'day'

class Day01 < Day
  def initialize
    @elves = input.split("\n\n").map do |elf|
      elf.lines(chomp: true).map(&:to_i)
    end
  end

  def totals
    @totals ||= @elves.map(&:sum).sort
  end

  def part_1
    totals.last
  end

  def part_2
    totals.last(3).sum
  end
end

Day01.run if __FILE__ == $0

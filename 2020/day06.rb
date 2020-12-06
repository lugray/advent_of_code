#!/usr/bin/env ruby

require_relative 'day'

class Group
  def initialize(yeses)
    @yeses = yeses
  end

  def any_yes_count
    @yeses.gsub("\n", '').each_char.uniq.size
  end

  def all_yes_count
    @yeses.each_line.map { |l| l.chomp.each_char.to_a }.inject(&:&).size
  end
end

class Day06 < Day
  def initialize
    @groups = input.split("\n\n").map { |yeses| Group.new(yeses) }
  end

  def part_1
    @groups.map(&:any_yes_count).sum
  end

  def part_2
    @groups.map(&:all_yes_count).sum
  end
end

Day06.run if __FILE__ == $0

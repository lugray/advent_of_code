#!/usr/bin/env ruby

require_relative 'day'

class Day02 < Day
  def initialize
    @ranges = input.split(",").map do |range|
      bounds = range.split("-").map(&:to_i)
      (bounds[0]..bounds[1])
    end
  end

  def each_id(&)
    return enum_for(:each_id) unless block_given?
    @ranges.each { |range| range.each(&) }
  end

  def sum_of_matching(pattern)
    each_id.select { |id| pattern.match?(id.to_s) }.sum
  end

  def part_1
    sum_of_matching(/^(.+)\1$/)
  end

  def part_2
    sum_of_matching(/^(.+)(\1)+$/)
  end
end

Day02.run if __FILE__ == $0

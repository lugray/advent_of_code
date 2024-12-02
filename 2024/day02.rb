#!/usr/bin/env ruby

require_relative 'day'

class Day02 < Day
  def initialize
    @reports = input_grid(&:to_i)
  end

  def safe?(report)
    sign = report[0] <=> report[1]
    report.each_cons(2).all? { |a, b| (1..3).include?((a - b) * sign) }
  end

  def part_1
    @reports.count { |report| safe?(report) }
  end

  def part_2
    @reports.count do |report|
      safe?(report) || report.combination(report.size - 1).any? { |r| safe?(r) }
    end
  end
end

Day02.run if __FILE__ == $0

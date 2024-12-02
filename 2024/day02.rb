#!/usr/bin/env ruby

require_relative 'day'

class Day02 < Day
  def initialize
    @reports = input_grid(&:to_i)
  end

  def safe?(report)
    diffs = report.each_cons(2).map { |a, b| b - a }
    diffs.all? { |diff| diff <= 3 && diff >= 1 } || diffs.all? { |diff| -diff <= 3 && -diff >= 1 }
  end

  def part_1
    @reports.count { |report| safe?(report) }
  end

  def part_2
    @reports.count do |report|
      next true if safe?(report)
      (0...report.size).any? do |i|
        safe?(report.dup.tap { |r| r.delete_at(i) })
      end
    end
  end
end

Day02.run if __FILE__ == $0

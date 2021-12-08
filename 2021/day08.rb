#!/usr/bin/env ruby

require_relative 'day'

class Day08 < Day
  class Line
    def initialize(line)
      a, b = line.split(' | ')
      @digits = a.split(' ').map { |w| w.chars.sort }
      @output = b.split(' ').map { |w| w.chars.sort }
    end

    def delete_first(digits, &block)
      digits.delete(digits.find(&block))
    end

    def create_map
      digits = @digits.dup
      map = {}
      map[1] = delete_first(digits) { |d| d.length == 2 }
      map[7] = delete_first(digits) { |d| d.length == 3 }
      map[4] = delete_first(digits) { |d| d.length == 4 }
      map[8] = delete_first(digits) { |d| d.length == 7 }
      map[9] = delete_first(digits) { |d| map[4].all? { |seg| d.include?(seg) } }
      map[0] = delete_first(digits) { |d| d.length == 6 && map[7].all? { |seg| d.include?(seg) } }
      map[3] = delete_first(digits) { |d| map[7].all? { |seg| d.include?(seg) } }
      map[6] = delete_first(digits) { |d| d.length == 6 }
      map[5] = delete_first(digits) { |d| (map[4] - map[1]).all? { |seg| d.include?(seg) } }
      map[2] = delete_first(digits) { |d| true }
      map.invert
    end

    def map
      @map ||= create_map
    end

    def output
      @output.map { |d| map[d] }.join.to_i
    end

    def count1478
      @output.count { |d| [1, 4, 7, 8].include?(map[d]) }
    end
  end

  def initialize
    @notes = input_lines.map { |l| Line.new(l) }
  end

  def part_1
    @notes.sum(&:count1478)
  end

  def part_2
    @notes.map(&:output).sum
  end
end

Day08.run if __FILE__ == $0

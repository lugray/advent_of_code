#!/usr/bin/env ruby

require_relative 'day'

class Day07 < Day
  def initialize
    @grid = input_lines.map {|l| l.each_char.to_a }
  end

  def part_1
    splits = 0
    @grid.each_with_object(Set.new) do |row, set|
      row.each_with_index do |char, i|
        case char
        when 'S'
          set << i
        when '^'
          if set.include?(i)
            splits += 1
            set.delete(i)
            set << i-1
            set << i+1
          end
        end
      end
    end
    splits
  end

  def part_2
    @grid.each_with_object(Hash.new(0)) do |row, paths|
      row.each_with_index do |char, i|
        case char
        when 'S'
          paths[i] = 1
        when '^'
          if (count = paths.delete(i))
            paths[i-1] += count
            paths[i+1] += count
          end
        end
      end
    end.values.sum
  end
end

Day07.run if __FILE__ == $0

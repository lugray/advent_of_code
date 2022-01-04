#!/usr/bin/env ruby

require_relative 'day'

class Day25 < Day
  def initialize
    @herd = input_lines.map do |line|
      line.chars
    end
  end

  def step_east(herd)
    moved = false
    new_herd = herd.map do |row|
      row.each_with_index.map do |c, i|
        if c == '.' && row[i - 1] == '>'
          moved = true
          '>'
        elsif c == '>' && row[(i + 1) % herd.first.size] == '.'
          '.'
        else
          c
        end
      end
    end
    [new_herd, moved]
  end

  def transpose(herd)
    herd.map do |row|
      row.map do |a|
        case a
        when '>'
          'v'
        when 'v'
          '>'
        when '.'
          '.'
        end
      end
    end.transpose
  end

  def step_south(herd)
    new_herd, moved = step_east(transpose(herd))
    [transpose(new_herd), moved]
  end

  def step(herd)
    new_herd, moved_east = step_east(herd)
    new_herd, moved_south = step_south(new_herd)
    [new_herd, moved_east || moved_south]
  end

  def part_1
    herd = @herd
    (1..).each do |count|
      herd, moved = step(herd)
      return count unless moved
    end
  end

  def part_2
  end
end

Day25.run if __FILE__ == $0

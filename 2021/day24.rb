#!/usr/bin/env ruby

require_relative 'day'

class Day24 < Day
  def initialize
    stack = []
    @ans1 = Array.new(14) { 9 }
    @ans2 = Array.new(14) { 1 }
    input_lines.each_slice(18).each_with_index do |slice, i|
      pop = slice[4] == 'div z 26'
      a = slice[5].split(' ').last.to_i
      b = slice[15].split(' ').last.to_i

      raise 'Unexpected peek without forced push' if !pop && a < 10
      raise 'Unexpected pop with forced push' if pop && a > 9

      if pop
        popped_i, popped_b = stack.pop
        diff = popped_b + a
        # puts "Constraint: Digit #{popped_i} + #{diff} == Digit #{i}"
        if diff > 0
          @ans1[i] = 9
          @ans1[popped_i] = 9 - diff
          @ans2[i] = diff + 1
          @ans2[popped_i] = 1
        else
          @ans1[popped_i] = 9
          @ans1[i] = 9 + diff
          @ans2[popped_i] = -diff + 1
          @ans2[i] = 1
        end
      else
        stack.push([i, b])
      end
    end
  end

  def part_1
    @ans1.join
  end

  def part_2
    @ans2.join
  end
end

Day24.run if __FILE__ == $0

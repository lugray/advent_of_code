#!/usr/bin/env ruby

require_relative 'day'
require_relative 'intcode'

class Day21 < Day
  def springscript(program)
    intcode = Intcode.new(input.split(',').map(&:to_i))
    intcode.run
    print intcode.outputs.map(&:chr).join
    intcode.outputs.clear
    intcode.with_inputs(*program.each_char.map(&:ord)).run
    print intcode.outputs.select { |i| i < 256 }.map(&:chr).join
    intcode.outputs.last
  end
  
  def part_1
    springscript(<<~EOF)
      NOT A J
      NOT B T
      OR T J
      NOT C T
      OR T J
      AND D J
      WALK
    EOF
  end

  def part_2
    springscript(<<~EOF)
      NOT A J
      NOT B T
      OR T J
      NOT C T
      OR T J
      AND D J
      NOT H T
      NOT T T
      OR E T
      AND T J
      RUN
    EOF
  end
end

Day21.run if __FILE__ == $0

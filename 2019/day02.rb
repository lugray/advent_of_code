#!/usr/bin/env ruby

require_relative 'aoc'

class Intcode
  def initialize(opcodes)
    @opcodes = opcodes
  end

  def with(replacements)
    ops = @opcodes.dup
    replacements.each do |at, to|
      ops[at] = to
    end
    Intcode.new(ops)
  end

  def run
    ops = @opcodes.dup
    i = 0
    loop do
      case ops[i]
      when 1
        ops[ops[i + 3]] = ops[ops[i + 1]] + ops[ops[i + 2]]
        i += 4
      when 2
        ops[ops[i + 3]] = ops[ops[i + 1]] * ops[ops[i + 2]]
        i += 4
      when 99
        break
      else
        raise "Unexpected opcode"
      end
    end
    Intcode.new(ops)
  end

  def value_at(n)
    @opcodes[n]
  end
end

intcode = Intcode.new(AOC.input.split(',').map(&:to_i))
puts intcode.with(1 => 12, 2 => 2).run.value_at(0)
(0..99).each do |noun|
  (0..99).each do |verb|
    if intcode.with(1 => noun, 2 => verb).run.value_at(0) == 19690720
      puts 100 * noun + verb
      break 2
    end
  end
end

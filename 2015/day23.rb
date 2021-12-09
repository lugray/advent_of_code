#!/usr/bin/env ruby

require_relative 'day'

class Day23 < Day
  class Computer
    def initialize(instructions, a: 0, b: 0)
      @register = { a: a, b: b }
      @instruction_pointer = 0
      @instructions = instructions
    end

    def a
      @register[:a]
    end

    def b
      @register[:b]
    end

    def run
      while (instruction = @instructions[@instruction_pointer])
        send(*instruction)
        @instruction_pointer += 1
      end
      self
    end

    private

    def hlf(r)
      @register[r] /= 2
    end

    def tpl(r)
      @register[r] *= 3
    end

    def inc(r)
      @register[r] += 1
    end

    def jmp(offset)
      @instruction_pointer += offset - 1
    end

    def jie(r, offset)
      @instruction_pointer += offset -1 if @register[r].even?
    end

    def jio(r, offset)
      @instruction_pointer += offset -1 if @register[r] == 1
    end
  end

  def initialize
    @instructions = input.each_line.map do |l|
      a, b, c = l.chomp.split(/,? /)
      [a.to_sym, parse_param(b), parse_param(c)].compact
    end
  end

  def parse_param(p)
    case p
    when 'a'
      :a
    when 'b'
      :b
    when /^[+-]\d+$/
      p.to_i
    end
  end

  def part_1
    Computer.new(@instructions).run.b
  end

  def part_2
    Computer.new(@instructions, a: 1).run.b
  end
end

Day23.run if __FILE__ == $0

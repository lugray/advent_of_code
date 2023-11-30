#!/usr/bin/env ruby

require_relative 'day'
require 'prime'

class Day23 < Day
  class Computer
    attr_reader :mul_count

    def initialize(code)
      @registers = Hash.new(0)
      @code = code
      @ip = 0
      @mul_count = 0
    end

    def value(x)
      if x.is_a?(Integer)
        x
      else
        @registers[x]
      end
    end

    def set(x, y)
      @registers[x] = value(y)
    end

    def sub(x, y)
      @registers[x] -= value(y)
    end

    def mul(x, y)
      @registers[x] *= value(y)
      @mul_count += 1
    end

    def jnz(x, y)
      @ip += value(y) - 1 if value(x) != 0
    end

    def run
      loop do
        break if @ip < 0 || @ip >= @code.size
        send(*@code[@ip])
        @ip += 1
      end
    end
  end
  def initialize
    @code = input_lines do |line|
      instruction, *args = line.split(' ')
      [instruction, *args.map { |arg| to_i_if_i(arg) }]
    end
  end

  def part_1
    Computer.new(@code).tap(&:run).mul_count
  end

  def part_2
    code = [['set', 'a', 1]] + @code[0..7]
    computer = Computer.new(code).tap(&:run)
    b = computer.value('b')
    c = computer.value('c')
    (b..c).step(17).count { |n| !n.prime? }
  end
end

Day23.run if __FILE__ == $0

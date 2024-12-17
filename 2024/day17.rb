#!/usr/bin/env ruby

require_relative 'day'

class Opcode
  OPCODES = [:adv, :bxl, :bst, :jnz, :bxc, :out, :bdv, :cdv]

  def initialize(reg, prog)
    @reg = reg
    @prog = prog
    @pc = 0
    @out = []
  end

  def combo(n)
    case n
    when 0, 1, 2, 3
      n
    when 4
      @reg[:A]
    when 5
      @reg[:B]
    when 6
      @reg[:C]
    when 7
      raise 'Invalid combo operand'
    end
  end

  def adv(n)
    @reg[:A] = @reg[:A] >> combo(n)
  end

  def bxl(n)
    @reg[:B] = @reg[:B] ^ n
  end

  def bst(n)
    @reg[:B] = combo(n) % 8
  end

  def jnz(n)
    return if @reg[:A] == 0
    @pc = n - 2
  end

  def bxc(_n)
    @reg[:B] = @reg[:B] ^ @reg[:C]
  end

  def out(n)
    @out << combo(n) % 8
  end

  def bdv(n)
    @reg[:B] = @reg[:A] >> combo(n)
  end

  def cdv(n)
    @reg[:C] = @reg[:A] >> combo(n)
  end

  def run
    while @pc < @prog.size
      op, n = @prog[@pc], @prog[@pc + 1]
      public_send(OPCODES[op], n)
      @pc += 2
    end
    @out
  end

  def quine?
    while @pc < @prog.size
      op, n = @prog[@pc], @prog[@pc + 1]
      public_send(OPCODES[op], n)
      if op ==5
        break unless @out.zip(@prog).all? { |a, b| a == b }
      end
      @pc += 2
    end
    @out == @prog
  end
end

class Day17 < Day
  def initialize
    reg, prog = input_paragraphs
    @reg = reg.each_line(chomp: true).each_with_object({}) do |line, h|
      a, b = line.split(': ')
      h[a[-1].to_sym] = b.to_i
    end
    @prog = prog.split(' ').last.split(',').map(&:to_i)
  end

  def part_1
    Opcode.new(@reg.dup, @prog.dup).run.join(',')
  end

  def part_2
    a = 0
    @prog.reverse.each do |n|
      a = a << 3
      loop do
        b = a % 8
        b = b ^ 5
        c = a >> b
        b = b ^ 6
        b = b ^ c
        break if b % 8 == n
        a += 1
      end
    end
    raise unless Opcode.new({A: a, B: 0, C: 0}, @prog.dup).quine?
    a
  end
end

Day17.run if __FILE__ == $0



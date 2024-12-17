#!/usr/bin/env ruby

require_relative 'day'

class Opcode
  OPCODES = [:adv, :bxl, :bst, :jnz, :bxc, :out, :bdv, :cdv]

  def initialize(prog, a: 0, b: 0, c: 0)
    @reg = { a:, b:, c: }
    @prog = prog
    @pc = 0
    @out = []
  end

  def combo(n)
    case n
    when 0, 1, 2, 3 then n
    when 4 then @reg[:a]
    when 5 then @reg[:b]
    when 6 then @reg[:c]
    end
  end

  def adv(n) = @reg[:a] = @reg[:a] >> combo(n)
  def bxl(n) = @reg[:b] = @reg[:b] ^ n
  def bst(n) = @reg[:b] = combo(n) % 8
  def jnz(n) = (@pc = n - 2 unless @reg[:a] == 0)
  def bxc(n) = @reg[:b] = @reg[:b] ^ @reg[:c]
  def out(n) = @out << combo(n) % 8
  def bdv(n) = @reg[:b] = @reg[:a] >> combo(n)
  def cdv(n) = @reg[:c] = @reg[:a] >> combo(n)

  def run
    while @pc < @prog.size
      op, n = @prog[@pc], @prog[@pc + 1]
      public_send(OPCODES[op], n)
      @pc += 2
    end
    @out
  end
end

class Day17 < Day
  def initialize
    reg, prog = input_paragraphs
    @reg = reg.each_line(chomp: true).each_with_object({}) do |line, h|
      a, b = line.split(': ')
      h[a[-1].downcase.to_sym] = b.to_i
    end
    @prog = prog.split(' ').last.split(',').map(&:to_i)
  end

  def part_1
    Opcode.new(@prog, **@reg).run.join(',')
  end

  def part_2
    a = 0
    @prog.reverse.each do |n|
      a = a << 3
      loop do
        out = Opcode.new(@prog, a: a).run
        break if out == @prog[-out.size..-1]
        a += 1
      end
    end
    a
  end
end

Day17.run if __FILE__ == $0



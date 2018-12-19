#!/usr/bin/env ruby

class CPU
  attr_accessor :reg

  def initialize(input)
    prog_lines = input.each_line.to_a
    @ip_reg = prog_lines.shift.chomp['#ip '.length..-1].to_i
    @program = prog_lines.map do |line|
      line.chomp.split(' ').map do |part|
        case part
        when /^\d+$/
          part.to_i
        else
          part.to_sym
        end
      end
    end
    @reg = [0, 0, 0, 0, 0, 0]
  end

  def run(verbose: false)
    loop do
      line = @program[ip]
      break if line.nil?
      puts @reg.inspect if verbose
      puts line.inspect if verbose
      send(*line)
      inc_ip
    end
    dec_ip
    @reg[0]
  end

  private

  def inc_ip
    @reg[@ip_reg] += 1
  end

  def dec_ip
    @reg[@ip_reg] -= 1
  end

  def ip
    @reg[@ip_reg]
  end

  def addr(a, b, c)
    @reg[c] = @reg[a] + @reg[b]
  end

  def addi(a, b, c)
    @reg[c] = @reg[a] + b
  end

  def mulr(a, b, c)
    @reg[c] = @reg[a] * @reg[b]
  end

  def muli(a, b, c)
    @reg[c] = @reg[a] * b
  end

  def banr(a, b, c)
    @reg[c] = @reg[a] & @reg[b]
  end

  def bani(a, b, c)
    @reg[c] = @reg[a] & b
  end

  def borr(a, b, c)
    @reg[c] = @reg[a] | @reg[b]
  end

  def bori(a, b, c)
    @reg[c] = @reg[a] | b
  end

  def setr(a, b, c)
    @reg[c] = @reg[a]
  end

  def seti(a, b, c)
    @reg[c] = a
  end

  def gtir(a, b, c)
    @reg[c] = a > @reg[b] ? 1 : 0
  end

  def gtri(a, b, c)
    @reg[c] = @reg[a] > b ? 1 : 0
  end

  def gtrr(a, b, c)
    @reg[c] = @reg[a] > @reg[b] ? 1 : 0
  end

  def eqir(a, b, c)
    @reg[c] = a == @reg[b] ? 1 : 0
  end

  def eqri(a, b, c)
    @reg[c] = @reg[a] == b ? 1 : 0
  end

  def eqrr(a, b, c)
    @reg[c] = @reg[a] == @reg[b] ? 1 : 0
  end
end

input = '#ip 0
seti 5 0 1
seti 6 0 2
addi 0 1 0
addr 1 2 3
setr 1 0 0
seti 8 0 4
seti 9 0 5
'
input = File.read('input')
cpu = CPU.new(input)
puts cpu.run
# cpu.reg = [1, 0, 0, 0, 0, 0]
# puts cpu.run(verbose: true)

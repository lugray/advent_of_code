#!/usr/bin/env ruby

class CPU
  OPERATIONS = [:addr, :addi, :muli, :mulr, :banr, :bani, :borr, :bori, :setr, :seti, :gtir, :gtri, :gtrr, :eqir, :eqri, :eqrr]

  def initialize(input)
    samples, program = input.split("\n\n\n\n")
    @samples = samples.each_line.each_slice(4).map do |lines|
      Sample.new(lines[0..2].join)
    end
    @program = program.each_line.map do |line|
      line.chomp.split(' ').map(&:to_i)
    end
    reset
  end

  def run
    reset
    @program.each do |line|
      send(@commands[line[0]], *line[1..3])
    end
    @reg[0]
  end

  def discover
    @commands = Array.new(16) { OPERATIONS.dup }
    @samples.each do |sample|
      @commands[sample.op[0]].select! do |op|
        could_be?(sample, op)
      end
    end
    loop do
      done, too_many  = @commands.group_by{|c| c.length ==1}.values_at(true, false)
      break if too_many.nil?
      too_many.each do |cs|
        cs.reject! {|c| done.map(&:first).include?(c)}
      end
    end
    @commands.map!(&:first)
  end

  def reset
    @reg = [0, 0, 0, 0]
  end

  def count_3_or_more
    c = @samples.select do |sample|
      possibilities(sample).count >= 3
    end.count
    reset
    c
  end

  private

  def possibilities(sample)
    OPERATIONS.select do |op|
      could_be?(sample, op)
    end
  end

  def could_be?(sample, op)
    @reg = sample.before.dup
    send(op, *sample.op[1..3])
    @reg == sample.after
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

  class Sample
    attr_reader :before, :op, :after

    def initialize(input)
      md = input.match(/Before: \[(\d+), (\d+), (\d+), (\d+)\]\n(\d+) (\d+) (\d+) (\d+)\nAfter:  \[(\d+), (\d+), (\d+), (\d+)\]/)
      raise "Bad input: \"#{input}\"" unless md
      nums = md.captures.map(&:to_i)
      @before = nums[0..3].freeze
      @op = nums[4..7].freeze
      @after = nums[8..11].freeze
    end
  end
end

input = 'Before: [3, 2, 1, 1]
9 2 1 2
After:  [3, 2, 2, 1]



0 0 0 0
'
input = File.read('input')
cpu = CPU.new(input)
puts cpu.count_3_or_more
cpu.discover
puts cpu.run

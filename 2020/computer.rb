#!/usr/bin/env ruby

class Computer
  attr_reader :accumulator, :inst

  def initialize(code)
    case code
    when String
      @code = code.each_line.map do |line|
        op, n = line.chomp.split(' ')
        [op, n.to_i]
      end
    else
      @code = code
    end
    reset
  end

  def to_s
    @code.map { |inst| inst.join(' ') }.join("\n")
  end

  def reset
    @inst = 0
    @accumulator = 0
    @each_step = []
    @halt_when = []
    @instructions = []
    self
  end

  def jmp_nop_swaps
    return enum_for(:jmp_nop_swaps) unless block_given?
    @code.each_with_index do |inst, i|
      case inst.first
      when 'nop'
        yield Computer.new(@code.dup.map(&:dup).tap { |code| code[i][0] = 'jmp' })
      when 'jmp'
        yield Computer.new(@code.dup.map(&:dup).tap { |code| code[i][0] = 'nop' })
      end
    end
  end

  def halts?
    each_step(&:track_inst).halt_when(&:dup_inst?).run
    !@code[@inst]
  end

  def run
    until halt? do
      step
    end
    self
  end

  def halt?
    return true unless @code[@inst]
    @halt_when.any? do |block|
      block.call(self)
    end
  end

  def step
    @each_step.each do |block|
      block.call(self)
    end
    case @code[@inst].first
    when 'acc'
      @accumulator += @code[@inst].last
      @inst += 1
    when 'jmp'
      @inst += @code[@inst].last
    when 'nop'
      @inst += 1
    end
  end

  def track_inst
    @instructions << @inst
  end

  def dup_inst?
    @instructions.include?(@inst)
  end

  def halt_when(&block)
    @halt_when << block
    self
  end

  def each_step(&block)
    @each_step << block
    self
  end
end

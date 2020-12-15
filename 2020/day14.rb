#!/usr/bin/env ruby

require_relative 'day'

class InitProg
  def initialize(input)
    @prog = input.each_line.map do |l|
      case l[0..3]
      when 'mask'
        _, m = l.split(' = ')
        [:mask, m.chomp]
      when 'mem['
        loc, val = l[4..].split('] = ').map(&:to_i)
        [:mem, loc, val]
      else
        raise 'Unexpected'
      end
    end
    @mem = {}
  end

  def run
    @prog.each do |inst|
      send(*inst)
    end
    self
  end

  def mask(m)
    @one_mask = m.each_char.map { |c| c == '1' ? '1' : '0' }.join.to_i(2)
    @zero_mask = m.each_char.map { |c| c == '0' ? '0' : '1' }.join.to_i(2)
  end

  def mem(loc, val)
    @mem[loc] = val & @zero_mask | @one_mask
  end

  def sum
    @mem.values.sum
  end
end

class InitProgV2
  def initialize(input)
    @prog = input.each_line.map do |l|
      case l[0..3]
      when 'mask'
        _, m = l.split(' = ')
        [:mask, m.chomp]
      when 'mem['
        loc, val = l[4..].split('] = ').map(&:to_i)
        [:mem, loc, val]
      else
        raise 'Unexpected'
      end
    end
    @mem = {}
  end

  def run
    @prog.each do |inst|
      send(*inst)
    end
    self
  end

  def mask(m)
    @mask = m
    @one_mask = m.each_char.map { |c| c == '1' ? '1' : '0' }.join.to_i(2)
    @xs = m.each_char.reverse_each.each_with_index.select { |c, i| c == 'X' }.map(&:last)
  end

  def masked(val, xs = @xs.dup)
    return enum_for(:masked, val, xs) unless block_given?
    val = val | @one_mask
    if xs.empty?
      yield val
      return
    end
    x = xs.pop
    v1 = val | 2**x
    v2 = val & (2**36-1-2**x)
    masked(v1, xs.dup).each { |v| yield v }
    masked(v2, xs.dup).each { |v| yield v }
  end

  def mem(loc, val)
    masked(loc).each do |l|
      @mem[l] = val
    end
    #puts @mem.inspect
  end

  def sum
    @mem.values.sum
  end
end

class Day14 < Day
  def part_1
    InitProg.new(input).run.sum
  end

  def part_2
    InitProgV2.new(input).run.sum
  end
end

Day14.run if __FILE__ == $0

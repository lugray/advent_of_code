#!/usr/bin/env ruby

require_relative 'day'

class Day24 < Day
  def initialize
    @vals = {}
    @ops = {}
    initials, operators = input_paragraphs
    initials.each_line(chomp: true) do |line|
      wire, value = line.split(': ')
      @vals[wire] = value.to_i
    end
    operators.each_line(chomp: true) do |line|
      a, op, b, _, wire = line.split(' ')
      @ops[wire] = [a, op, b]
    end
  end

  def val(wire)
    @vals[wire] ||= @ops[wire].then do |a, op, b|
      case op
      when 'AND'
        val(a) & val(b)
      when 'OR'
        val(a) | val(b)
      when 'XOR'
        val(a) ^ val(b)
      end
    end
  end

  def part_1
    @ops.keys.select { |wire| wire.start_with?('z') }.sum do |wire|
      val(wire) * 2 ** wire[1..-1].to_i
    end
  end

  def normal?(wire)
    raise 'Checks only z wires' unless wire.start_with?('z')
    ret = true
    n = wire[1..-1]
    return true if n.to_i == 0 || n.to_i == 45
    a, op, b = @ops[wire]
    unless op == 'XOR'
      puts "Not XOR: #{wire}, op: #{op}, a: #{a}, b: #{b}"
      ret = false
    end
    return ret unless @ops[a]
    if @ops[a][1] != 'XOR'
      a, b = b, a
    end
    unless @ops[a][1] == 'XOR'
      puts "Not XOR2: #{wire}, op: #{@ops[a][1]}, a: #{@ops[a][0]}, b: #{@ops[a][2]}"
      ret = false
    end
    ret = false unless [@ops[a][0], @ops[a][2]].sort == ["x#{n}", "y#{n}"]
    ret
  end

  def invert_ops(*parts)
    @ops.find { |k, v| v.sort == parts.sort }.first
  end

  def swap(wire1, wire2)
    @ops[wire1], @ops[wire2] = @ops[wire2], @ops[wire1]
    @bad_wires << wire1
    @bad_wires << wire2
  end

  def part_2
    @bad_wires = []
    and1out = Array.new(46)
    and2out = Array.new(46)
    xorout = Array.new(46)
    carryout = Array.new(46)

    n = 0
    x = "x#{n.to_s.rjust(2, "0")}"
    y = "y#{n.to_s.rjust(2, "0")}"

    and1out[n] = invert_ops("AND", x, y)
    xorout[n] = invert_ops("XOR", x, y)
    carryout[n] = and1out[n]

    (1..44).each do |n|
      x = "x#{n.to_s.rjust(2, "0")}"
      y = "y#{n.to_s.rjust(2, "0")}"
      z = "z#{n.to_s.rjust(2, "0")}"
      and1out[n] = invert_ops("AND", x, y)
      xorout[n] = invert_ops("XOR", x, y)
      wire1, op, wire2 = @ops[z]
      wires = [wire1, wire2]
      if wires.include?(carryout[n-1]) && !wires.include?(xorout[n])
        bad_wire = (wires - [carryout[n-1]]).first
        swap(bad_wire, xorout[n])
      elsif wires.include?(xorout[n]) && !wires.include?(carryout[n-1])
        bad_wire = (wires - [xorout[n]]).first
        swap(bad_wire, carryout[n-1])
      elsif invert_ops("XOR", xorout[n], carryout[n-1]) != z
        swap(z, invert_ops("XOR", xorout[n], carryout[n-1]))
      end
      and1out[n] = invert_ops("AND", x, y)
      xorout[n] = invert_ops("XOR", x, y)
      and2out[n] = invert_ops("AND", xorout[n], carryout[n-1])
      carryout[n] = invert_ops("OR", and1out[n], and2out[n])
    end
    @bad_wires.sort.join(',')
  end
end

Day24.run if __FILE__ == $0

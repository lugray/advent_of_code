#!/usr/bin/env ruby

require_relative 'day'
require 'z3'

class Day10 < Day
  class Machine
    def initialize(line)
      lights, rest = line.split('] (')
      @lights = lights[1..].tr('.#', '01').reverse.to_i(2)
      buttons, joltage = rest.split(') {')
      @joltage = joltage.ints
      @raw_buttons = buttons.split(') (').map(&:ints)
      @buttons = @raw_buttons.map { |b| b.sum { |i| 1 << i } }
    end

    def shortest_button_pattern_length
      button_patterns.map { |p| p.to_s(2).each_char.count('1') }.min
    end

    def button_patterns
      (0...(2**@buttons.size)).select do |mask|
        @buttons.each_with_index.select { |b, i| (mask & (1 << i)) != 0 }.map(&:first).inject(0, :^) == @lights
      end
    end

    def min_presses
      solver = Z3::Optimize.new
      counts = @raw_buttons.each_with_index.map do |b, bi|
        c = Z3::Int(bi.to_s)
        solver.assert(c >= 0)
        c
      end
      @joltage.each_with_index do |j, ji|
        solver.assert(@raw_buttons.each_with_index.filter_map { |b, bi| counts[bi] if b.include?(ji) }.inject(&:+) == j)
      end
      total = Z3::Int('total')
      solver.assert(total == counts.inject(&:+))
      solver.minimize(total)
      raise "Not possible" unless solver.satisfiable?
      solver.model[total].to_i
    end
  end

  def initialize
    @machines = input_lines.map{ |l| Machine.new(l) }
  end

  def part_1
    @machines.map(&:shortest_button_pattern_length).sum
  end

  def part_2
    @machines.map(&:min_presses).sum
  end
end

Day10.run if __FILE__ == $0

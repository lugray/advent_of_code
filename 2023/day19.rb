#!/usr/bin/env ruby

require_relative 'day'

Part = Struct.new(:x, :m, :a, :s)

class Constraint
  def initialize(mins = { x: 1, m: 1, a: 1, s: 1 }, maxs = { x: 4_000, m: 4_000, a: 4_000, s: 4_000 })
    @mins = mins
    @maxs = maxs
  end

  def dup
    self.class.new(@mins.dup, @maxs.dup)
  end

  def constrain(rule)
    prop = rule[0].to_sym
    gtlt = rule[1]
    val = rule[2..].to_i
    case gtlt
    when '>'
      @mins[prop] = [@mins[prop], val+1].max
    when '<'
      @maxs[prop] = [@maxs[prop], val-1].min
    end
    self
  end

  def reverse_constrain(rule)
    prop = rule[0].to_sym
    gtlt = rule[1]
    val = rule[2..].to_i
    case gtlt
    when '>'
      @maxs[prop] = [@maxs[prop], val].min
    when '<'
      @mins[prop] = [@mins[prop], val].max
    end
    self
  end

  def size
    @mins.keys.map { |k| [@maxs[k] - @mins[k] + 1, 0].max }.reduce(:*)
  end

  def allows?(part)
    @mins.keys.all? { |k| @mins[k] <= part[k] && part[k] <= @maxs[k] }
  end
end

class Day19 < Day
  def initialize
    wf, pt = input_paragraphs
    @workflows = wf.each_line(chomp: true).each_with_object({}) do |line, h|
      name, rest = line.split('{')
      h[name] = rest[0...-1].split(',')
    end
    @constraints = constraints_for('in')
    @parts = pt.each_line(chomp: true).map do |line|
      _, x, m, a, s = line.split('=').map(&:to_i)
      Part.new(x, m, a, s)
    end
  end

  def constraints_for(name, constraint = Constraint.new)
    return [constraint] if name == 'A'
    return [] if name == 'R'
    @workflows[name][0..-2].map do |rules|
      cond, next_name = rules.split(':')
      this = constraint.dup.constrain(cond)
      constraint.reverse_constrain(cond)
      constraints_for(next_name, this)
    end.flatten + constraints_for(@workflows[name].last, constraint)
  end

  def part_1
    @parts.select do |part|
      @constraints.any? { |c| c.allows?(part) }
    end.sum do |part|
      part.x + part.m + part.a + part.s
    end
  end

  def part_2
    @constraints.sum(&:size)
  end
end

Day19.run if __FILE__ == $0

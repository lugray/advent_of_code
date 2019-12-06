#!/usr/bin/env ruby

require_relative 'day'

class Planet
  attr_accessor :parent, :children

  def initialize
    @children = []
  end

  def orbits(mult = 1)
    mult * @children.count + @children.sum { |p| p.orbits(mult + 1) }
  end

  def ancestors
    return [] if parent.nil?
    [parent] + parent.ancestors
  end
end

class Universe
  def initialize(input)
    @planets = Hash.new { |h, k| h[k] = Planet.new }

    input.lines.each do |l|
      add(*l.chomp.split(')').map { |name| @planets[name] })
    end
  end

  def add(p1, p2)
    p1.children.push(p2)
    p2.parent = p1
  end
  
  def orbits
    @planets['COM'].orbits
  end

  def distance(p1, p2)
    p1a = @planets[p1].ancestors
    p2a = @planets[p2].ancestors

    d1 = p2a.each_with_index.find do |p, i|
      p1a.include?(p)
    end.last

    d2 = p1a.each_with_index.find do |p, i|
      p2a.include?(p)
    end.last

    d1 + d2
  end
end

class Day06 < Day
  def part_1
    Universe.new(input).orbits
  end

  def part_2
    Universe.new(input).distance('YOU', 'SAN')
  end
end

Day06.run if __FILE__ == $0

#!/usr/bin/env ruby

require_relative 'day'
require 'matrix'

class Moon
  attr_reader :position, :velocity

  def initialize(x, y, z)
    @position = Vector[x, y, z]
    @velocity = Vector[0, 0, 0]
  end

  def initialize_copy(_)
    @position = @position.dup
    @velocity = @velocity.dup
  end

  def accel_to(other)
    (0..2).each { |i| @velocity[i] += other.position[i] <=> @position[i] }
  end

  def move
    @position += @velocity
  end

  def energy
    @position.to_a.map(&:abs).sum * @velocity.to_a.map(&:abs).sum
  end

  def ==(other)
    @position == other.position && @velocity == other.velocity
  end

  def to_s
    "Moon: #{[@position, @velocity].inspect}"
  end
end

class Day12 < Day
  def initialize
    @moons = input.lines.map { |l| Moon.new(*l.chomp.split(',').map { |v| v.gsub(/[xyz=<>]/,'').to_i }) }
  end

  def step
    @moons.each do |m1|
      @moons.each do |m2|
        m1.accel_to(m2)
      end
    end
    @moons.each do |m|
      m.move
    end
  end

  def part_1
    1000.times { step }
    @moons.sum(&:energy)
  end

  def part_2
    orig = @moons.map(&:dup)
    counts = Array.new(3, 0)
    counting = Array.new(3, true)
    loop do
      step
      (0..2).each do |i|
        counts[i] += 1 if counting[i]
        counting[i] &&= !@moons.zip(orig).all? { |m1, m2| m1.position[i] == m2.position[i] && m1.velocity[i] == m2.velocity[i] }
      end
      break if counting.none?
    end
    counts.inject(1) { |a, b| a.lcm(b) }
  end
end

Day12.run if __FILE__ == $0

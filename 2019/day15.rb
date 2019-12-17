#!/usr/bin/env ruby

require_relative 'day'
require_relative 'intcode'
require 'io/console'

class Found < StandardError; end

class Robot
  def initialize(input)
    @intcode = Intcode.new(input.split(',').map(&:to_i))
    @x = 0
    @y = 0
  end

  def go(dir)
    case dir
    when 1
      @y += 1
    when 2
      @y -= 1
    when 3
      @x -= 1
    when 4
      @x += 1
    end
    @intcode.with_inputs(dir).run
    self
  end

  def outputs
    @intcode.outputs
  end

  def initialize_copy(_)
    @intcode = @intcode.dup
  end

  def pos
    [@x, @y]
  end

  def self_if_valid
    return nil if $visited[[@x, @y]]
    $visited[pos] = true
    case outputs.shift
    when 0
      nil
    when 1
      self
    when 2
      $o_tank_robot = self
      throw :found
    else
      raise 'what?'
    end
  end

  def next_steps
    (1..4).map do |dir| 
      dup.go(dir).self_if_valid
    end
  end
end

class Day15 < Day
  def part_1
    robots = [Robot.new(input)]
    $visited = { robots.first.pos => true }
    i = 0
    catch :found do
      loop do
        i += 1
        robots = robots.flat_map { |r| r.next_steps }.compact
      end
    end
    i
  end

  def part_2
    part_1
    robots = [$o_tank_robot]
    $visited = { robots.first.pos => true }
    i = 0
    loop do
      robots = robots.flat_map { |r| r.next_steps }.compact
      break if robots.count == 0
      i += 1
    end
    i
  end
end

Day15.run if __FILE__ == $0

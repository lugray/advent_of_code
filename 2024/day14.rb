#!/usr/bin/env ruby

require_relative 'day'

class Day14 < Day
  def initialize
    @robots = input_lines.map { |line| line.scan(/-?\d+/).map(&:to_i) }
    @mx, @my = ARGV.include?('--example') ? [11, 7] : [101, 103]
  end

  def robots_after(t) = @robots.map { |x, y, vx, vy| [(x + vx * t) % @mx, (y + vy * t) % @my] }

  def part_1
    t = 100
    robots = robots_after(100).map { |x, y| [x <=> (@mx / 2), y <=> (@my / 2)] }.reject { |a, b| a.zero? || b.zero? }.tally.values.inject(:*)
  end

  def show(t)
    robots = robots_after(t)
    puts ((0..@my).map do |y|
      (0..@mx).map do |x|
        robots.any? { |rx, ry| x == rx && y == ry } ? '#' : '.'
      end.join
    end.join("\n"))
  end

  def part_2
    n = 7
    loop do
      break if n % 103 == 53
      n += 101
    end
    show(n)
    puts n
  end
end

Day14.run if __FILE__ == $0

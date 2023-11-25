#!/usr/bin/env ruby

require_relative 'day'

class Day18 < Day
  def initialize
    @droplets = input_grid(',')
  end

  def neighbors(x, y, z)
    return enum_for(:neighbors, x, y, z) unless block_given?
    yield [x - 1, y, z]
    yield [x + 1, y, z]
    yield [x, y - 1, z]
    yield [x, y + 1, z]
    yield [x, y, z - 1]
    yield [x, y, z + 1]
  end

  def part_1
    dh = @droplets.each_with_object({}) { |pos, h| h[pos] = true }
    dh.sum do |pos, _|
      neighbors(*pos).count { |pos| dh[pos].nil? }
    end
  end

  def start_bubble(dh, x, y, z, outer_sets, inner_sets, max_bubble)
    return if inner_sets.any? { |s| s.include?([x, y, z]) }
    return if outer_sets.any? { |s| s.include?([x, y, z]) }
    return if dh.include?([x, y, z])
    s = Set.new
    s << [x, y, z]
    grow_bubble(dh, x, y, z, s, max_bubble)
    if s.size <= max_bubble
      inner_sets << s
    else
      outer_sets << s
    end
  end

  def grow_bubble(dh, x, y, z, s, max_bubble)
    candidates = neighbors(x, y, z).to_a
    loop do
      return if s.size > max_bubble
      pos = candidates.shift
      return unless pos
      next if dh.include?(pos)
      next if s.include?(pos)
      s << pos
      neighbors(*pos).each { |pos| candidates << pos }
    end
  end

  def part_2
    dh = @droplets.each_with_object({}) { |pos, h| h[pos] = true }
    outer_sets = []
    inner_sets = []
    max_bubble = (((Math.sqrt(12 * @droplets.size - 3) - 3) / 6).floor)**3
    dh.each do |pos, _|
      neighbors(*pos).each { |npos| start_bubble(dh, *npos, outer_sets, inner_sets, max_bubble) }
    end
    inner_sets.each do |s|
      s.each { |pos| dh[pos] = true } # fill in the inner bubbles so we can count the same way as part 1
    end
    dh.sum do |pos, _|
      neighbors(*pos).count { |pos| dh[pos].nil? }
    end
  end
end

Day18.run if __FILE__ == $0

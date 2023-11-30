#!/usr/bin/env ruby

require_relative 'day'

class Day23 < Day
  class NanoBot
    attr_reader :x, :y, :z, :r

    def initialize(x, y, z, r)
      @x = x
      @y = y
      @z = z
      @r = r
    end

    def distance_to(other)
      (@x - other.x).abs + (@y - other.y).abs + (@z - other.z).abs
    end

    def in_range?(other)
      distance_to(other) <= @r
    end

    def overlaps?(other)
      distance_to(other) <= @r + other.r
    end

    def d_origin
      @x.abs + @y.abs + @z.abs
    end
  end

  def initialize
    @bots = input_lines do |line|
      pos, r = line.delete_prefix('pos=<').delete_suffix('>').split('>, r=')
      NanoBot.new(*pos.split(',').map(&:to_i), r.to_i)
    end
  end

  def part_1
    strongest = @bots.max_by(&:r)
    @bots.count { |bot| strongest.in_range?(bot) }
  end

  def part_2
    arr = []
    @bots.each do |bot|
      arr << [[bot.d_origin - bot.r, 0].max, :start]
      arr << [bot.d_origin + bot.r, :end]
    end
    max_count = 0
    best_dist = 0
    count = 0
    arr.sort.group_by(&:first).transform_values! { |v| v.map(&:last) }.each do |dist, events|
      count += events.count(:start) - events.count(:end)
      if count > max_count
        max_count = count
        best_dist = dist
      end
    end
    best_dist
  end
end

Day23.run if __FILE__ == $0

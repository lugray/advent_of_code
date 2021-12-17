#!/usr/bin/env ruby

require_relative 'day'

class Day17 < Day
  def initialize
    _, _,xr, yr = input.split(/,? x?y?=?/)
    @x_min, @x_max = xr.split('..').map(&:to_i).sort
    @y_min, @y_max = yr.split('..').map(&:to_i).sort
    @xr = (@x_min..@x_max)
    @yr = (@y_min..@y_max)
  end

  def y(vy, t)
    vy * t - (t-1)*t/2
  end

  def x(vx, t)
    t = [t, vx].min
    vx * t - (t-1)*t/2
  end

  def lands?(vx, vy)
    # minimum for t from time to arrive in x without drag
    # maximum for t from time to drop past last line after max height
    (@x_min/vx..2*@y_min.abs + 1).any? do |t|
      x = x(vx, t)
      y = y(vy, t)
      return false if y < @y_min # We've already gone too far
      @xr.include?(x) && @yr.include?(y)
    end
  end

  def part_1
    @y_min.abs * (@y_min.abs - 1) / 2
  end

  def part_2
    vx_min = (Integer.sqrt(8*@x_min + 1) - 1) / 2 # From quadratic formula on x(vx, vx) == @x_min, since x maxes out at t=vx
    (@y_min..-@y_min).sum do |vy| # Shoot straight to last line in one step/to max height before dropping to last line
      (vx_min..@x_max).count { |vx| lands?(vx, vy) }
    end
  end
end

Day17.run if __FILE__ == $0

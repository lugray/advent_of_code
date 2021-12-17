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
    (@x_min/vx..2*@y_min.abs + 1).any? do |t|
      x = x(vx, t)
      y = y(vy, t)
      return false if y < @y_min
      @xr.include?(x) && @yr.include?(y)
    end
  end

  def part_1
    @y_min.abs * (@y_min.abs - 1) / 2
  end

  def part_2
    vx_min = (Integer.sqrt(8*@x_min + 1) - 1) / 2
    (@y_min..-@y_min).sum do |vy|
      (vx_min..@x_max).count { |vx| lands?(vx, vy) }
    end
  end
end

Day17.run if __FILE__ == $0

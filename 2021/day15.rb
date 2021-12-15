#!/usr/bin/env ruby

require_relative 'day'

class Day15 < Day
  def initialize
    @risk = {}
    input.each_line.each_with_index do |l, y|
      l.chomp.each_char.each_with_index do |c, x|
        @risk[[x, y]] = c.to_i
      end
    end
    init_ltr
    @schedule = []
  end

  def init_ltr
    @ltr = @risk.transform_values { Float::INFINITY }
    @ltr[[0, 0]] = 0
  end

  def paint_out(p)
    x, y = p
    [
      [x-1, y],
      [x+1, y],
      [x, y-1],
      [x, y+1],
    ].each do |n|
      if @ltr[n] && @ltr[p] + @risk[n] < @ltr[n]
        @ltr[n] = @ltr[p] + @risk[n]
        schedule(n)
      end
    end
  end

  def schedule(p)
    @schedule << p
  end

  def get_scheduled
    ret = @schedule
    @schedule = []
    ret
  end

  def far_corner_ltr
    schedule([0,0])
    loop do
      break if @schedule.empty?
      get_scheduled.each do |s|
        paint_out(s)
      end
    end
    max_x, max_y = @risk.keys.max
    # puts ((0..max_y).map do |y|
    #   (0..max_x).map { |x| @risk[[x, y]].to_s }.join
    # end)
    @ltr[@ltr.keys.max]
  end

  def expand_grid
    mx, my = @risk.keys.max
    sx = mx + 1
    sy = my + 1
    @risk.keys.each do |(x, y)|
      (0...5).each do |dx|
        (0...5).each do |dy|
          next if dx == 0 && dy == 0
          @risk[[x+dx*sx, y+dy*sy]] = ((@risk[[x,y]] + dx + dy) % 9).nonzero? || 9
        end
      end
    end
  end

  def part_1
    far_corner_ltr
  end

  def part_2
    expand_grid
    init_ltr
    far_corner_ltr
  end

  def input
    return super
    <<~I
      1163751742
      1381373672
      2136511328
      3694931569
      7463417111
      1319128137
      1359912421
      3125421639
      1293138521
      2311944581
    I
  end
end

Day15.run if __FILE__ == $0

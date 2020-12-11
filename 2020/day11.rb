#!/usr/bin/env ruby

require_relative 'day'
require 'matrix'

class SeatLife
  def initialize(input)
    @seats = input.each_line.map { |l| l.chomp.each_char.to_a }
    @rows = @seats.size
    @cols = @seats.first.size
  end

  def to_s
    @seats.map(&:join).join("\n")
  end

  def step
    changed = false
    @seats = @rows.times.map do |r|
      @cols.times.map do |c|
        case @seats[r][c]
        when '.'
          '.'
        when 'L'
          case surround_count(r, c)
          when 0
            changed = true
            '#'
          else
            'L'
          end
        when '#'
          case surround_count(r, c)
          when (0..3)
            '#'
          else
            changed = true
            'L'
          end
        else
          raise "Seat #{r},#{c} has unexpected contents: #{@seats[r][c]}"
        end
      end
    end
    changed
  end

  def run_to_stable
    while step do
    end
    self
  end

  def occupied_count
    @seats.sum { |r| r.count { |s| s == '#' } }
  end

  def surround_count(r, c)
    rmin = [0, r-1].max
    rmax = [r+1, @rows-1].min
    cmin = [0, c-1].max
    cmax = [c+1, @cols-1].min
    count = (rmin..rmax).sum do |sr|
      (cmin..cmax).count do |sc|
        @seats[sr][sc] == '#'
      end
    end
    count -= 1 if @seats[r][c] == '#'
    count
  end
end

class SightlineSeatLife
  def initialize(input)
    @seats = input.each_line.map { |l| l.chomp.each_char.to_a }
    @rows = @seats.size
    @cols = @seats.first.size
  end

  def to_s
    @seats.map(&:join).join("\n")
  end

  def step
    changed = false
    @seats = @rows.times.map do |r|
      @cols.times.map do |c|
        case @seats[r][c]
        when '.'
          '.'
        when 'L'
          case surround_count(r, c)
          when 0
            changed = true
            '#'
          else
            'L'
          end
        when '#'
          case surround_count(r, c)
          when (0..4)
            '#'
          else
            changed = true
            'L'
          end
        else
          raise "Seat #{r},#{c} has unexpected contents: #{@seats[r][c]}"
        end
      end
    end
    changed
  end

  def run_to_stable
    while step do
    end
    self
  end

  def occupied_count
    @seats.sum { |r| r.count { |s| s == '#' } }
  end

  def status(vector)
    r, c = vector.to_a
    return ' ' if r < 0 || c < 0
    @seats.fetch(r, []).fetch(c, ' ')
  end

  def surround_count(r, c)
    start = Vector[r, c]
    directions = ((-1..1).to_a.product((-1..1).to_a) - [[0,0]]).map(&Vector.method(:new))
    directions.count do |dir|
      m = 1
      while status(start + m * dir) == '.'
        m += 1
      end
      status(start + m * dir) == '#'
    end
  end
end

class Day11 < Day
  def initialize
  end

  def part_1
    SeatLife.new(input).run_to_stable.occupied_count
  end

  def part_2
    SightlineSeatLife.new(input).run_to_stable.occupied_count
  end

  def input
    return super
    <<~INPUT
      L.LL.LL.LL
      LLLLLLL.LL
      L.L.L..L..
      LLLL.LL.LL
      L.LL.LL.LL
      L.LLLLL.LL
      ..L.L.....
      LLLLLLLLLL
      L.LLLLLL.L
      L.LLLLL.LL
    INPUT
  end
end

Day11.run if __FILE__ == $0

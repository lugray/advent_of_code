#!/usr/bin/env ruby

require_relative 'day'

class SeatLife
  DIRECTIONS = (-1..1).to_a.product((-1..1).to_a) - [[0,0]]

  def initialize(input, sightline: false, max_neighbour: 3)
    @seats = input.each_line.map { |l| l.chomp.each_char.to_a }
    @sightline = sightline
    @max_neighbour = max_neighbour
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
          if surround_count_lte(r, c, 0)
            changed = true
            '#'
          else
            'L'
          end
        when '#'
          if surround_count_lte(r, c, @max_neighbour)
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

  def status(r, c)
    return ' ' if r < 0 || c < 0
    @seats.fetch(r, []).fetch(c, ' ')
  end

  def surround_count_lte(r, c, max)
    count = 0
    DIRECTIONS.each do |(dr, dc)|
      m = 1
      if @sightline
        while status(r + m * dr, c + m * dc) == '.'
          m += 1
        end
      end
      if status(r + m * dr, c + m * dc) == '#'
        count += 1
        return false if count > max
      end
    end
    true
  end
end

class Day11 < Day
  def initialize
  end

  def part_1
    SeatLife.new(input).run_to_stable.occupied_count
  end

  def part_2
    SeatLife.new(input, sightline: true, max_neighbour: 4).run_to_stable.occupied_count
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

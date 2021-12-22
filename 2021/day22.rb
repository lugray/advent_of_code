#!/usr/bin/env ruby

require_relative 'day'

class Day22 < Day
  def initialize
    @grid = Array.new(101) { Array.new(101) { Array.new(101) { false } } }
    input_lines.each do |line|
      state, rest = line.split(' ')
      parts = rest.split(',').map { |p| eval(p[2..]) }
      parts[0].each do |x|
        parts[1].each do |y|
          parts[2].each do |z|
            @grid[x+50][y+50][z+50] = state == 'on'
          end
        end
      end
    end
  end

  def part_1
    @grid.flatten.count(&:itself)
  end

  def part_2
  end

  def input
    <<~I
      on x=-39..5,y=-35..13,z=-14..36
      on x=-39..12,y=-43..6,z=-4..42
      on x=-18..35,y=-24..21,z=-12..34
      on x=-2..48,y=-14..38,z=-9..44
      on x=-14..40,y=-37..13,z=-47..4
      on x=-34..18,y=-5..43,z=-46..5
      on x=-37..13,y=-37..12,z=-43..6
      on x=-15..32,y=-4..42,z=-49..3
      on x=-12..34,y=-7..37,z=-11..35
      on x=-49..-2,y=-24..21,z=-23..21
      off x=-41..-30,y=34..43,z=17..29
      on x=-35..18,y=-19..31,z=-49..-3
      off x=8..27,y=34..44,z=-42..-23
      on x=-8..40,y=-19..30,z=-8..37
      off x=5..21,y=4..18,z=-18..-6
      on x=-5..47,y=-34..15,z=-10..34
      off x=36..47,y=16..30,z=-43..-31
      on x=-26..18,y=-37..9,z=-14..31
      off x=-48..-31,y=-14..5,z=-46..-29
      on x=-7..43,y=-47..3,z=-43..2
    I
  end
end

Day22.run if __FILE__ == $0

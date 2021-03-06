#!/usr/bin/env ruby

require_relative 'day'
require_relative 'intcode'
require 'io/console'

class Found < StandardError; end

class Robot
  def initialize(x, y)
    @keys = '_'
    @x = x
    @y = y
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

    return nil if $visited[pos]
    case $map[@x][@y]
    when '.', '@'
      $visited[pos] = true
      self
    when /[a-z]/
      @keys = (@keys.each_char.to_a + [$map[@x][@y]]).uniq.sort.join
      if @keys.length == $key_count + 1
        throw :found
      end
      $visited[pos] = true
      self
    when Regexp.new("[#{@keys.upcase}]")
      $visited[pos] = true
      self
    else
      nil
    end
  end

  def initialize_copy(_)
    @keys = @keys.dup
  end

  def pos
    [@keys, @x, @y]
  end

  def next_steps
    (1..4).map do |dir| 
      dup.go(dir)
    end
  end
end

class Robot
  def initialize(x, y)
    @keys = '_'
    @x = x
    @y = y
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

    return nil if $visited[pos]
    case $map[@x][@y]
    when '.', '@'
      $visited[pos] = true
      self
    when /[a-z]/
      @keys = (@keys.each_char.to_a + [$map[@x][@y]]).uniq.sort.join
      if @keys.length == $key_count + 1
        throw :found
      end
      $visited[pos] = true
      self
    when Regexp.new("[#{@keys.upcase}]")
      $visited[pos] = true
      self
    else
      nil
    end
  end

  def initialize_copy(_)
    @keys = @keys.dup
  end

  def pos
    [@keys, @x, @y]
  end

  def next_steps
    (1..4).map do |dir| 
      dup.go(dir)
    end
  end
end

class Day18 < Day
  def part_1(map = input)
    $map = map.each_line.map { |l| l.chomp.each_char.to_a }
    $key_count = 0
    sx = nil
    sy = nil
    $map.each_with_index do |l, x|
      l.each_with_index do |c, y|
        case c
        when /[a-z]/
          $key_count += 1
        when '@'
          sx = x
          sy = y
        end
      end
    end
    robots = [Robot.new(sx, sy)]
    $visited = { robots.first.pos => true }
    i = 0
    catch :found do
      loop do
        i += 1
        robots = robots.flat_map { |r| r.next_steps }.compact
        break if robots.empty?
      end
    end
    i
  end

  def q1
'#########################################
#l....#.........#.....#.....#...........#
#.#.###.#####.#.#####.#.###.#.###.#####.#
#.#.....#.#...#i......#.#...#.Z.#.....#.#
#.#####.#.#.###########.#.###.#######.###
#.#...#.#.#.....#...#...#.....#.....#...#
#.#.#.#.#.#####.#.#.#.#########.###.###.#
#.#.#.#.......#...#.#.#.#.......#.....#.#
#.#.#.#############.#.#.#.###########.#.#
#.#.#...............#.#.#.....#...#...#.#
#.#.###############.#.#.#####.#.#.###.#.#
#.#...#.......#.#...#...#...#...#...#.#.#
#####.#.#####.#.#.#####.###.#####.#.#.#.#
#.....#.#.....#.#...#.......#...#.#.#.#.#
#.#####.#.#####T###.#.#######.#.###.#.#.#
#.......#.#.........#...#.....#.....#.#.#
#.#######.###########.###.###########.#.#
#.#...#...#.......#...#...#.......#...#d#
#.###.#.###.#####.#.###.###.#####.#.###.#
#.....#g..#.#...#.#...#.#.#...#...#...#.#
#####.###.#.###.#.#.###.#.#.#.#.#####.#.#
#.......#.......#.#.#...#.#.#.#...#...#.#
#############.###.#.#####.#.#.###.#.###.#
#.........#...#...#.....#.#.#.#.#.#.#...#
#.#######.###.#.#######.#.#.#.#.#.#.#.#B#
#.#.....#...#.#.......#.#.#.#.#...#.#.#.#
#.###.#.###.#######.#.#.#.#.#.#.###.###.#
#...#.#...#...#...#.#...#...#.#.#...#...#
###.#.#.#####.#.#.#.#####.###.#.#.###.###
#...#.#.#...#...#.#...#...#...#.#.#.....#
#.###.#.#.#.#####.###.#####.#.###.#.###.#
#.#...#...#.....#...#.......#.#...#.#...#
#.#########.#.#.###.###.#######.###.#.#.#
#.#.......#.#.#.#.#.#...#.......#...#.#.#
#.#.#####.###.#.#.#.#####.###########.#.#
#.#...#.#.....#.#.#...#...#...........#.#
#.###.#.#######.#.###.#.#########.#####.#
#...#.#...#.....#...#...#.......#...#...#
###.#.#.###.#####.#.#####.#####.###.#.###
#w....#...........#.......#.........#..@#
#########################################'
  end

  def q2
'#########################################
#...........#.......#...#...............#
#.#.#########.#####.#.#.#.#####.#.#######
#.#e......A...#...#.#.#..q#...#.#.#.....#
#.#########.#####.#.#.#####.#.#.###.###.#
#...#.....#.......#.#...#...#.#.#.....#.#
#.###.###.#######.#.#.###.###.#.#.#####F#
#.#...#.#...#.....#.#.#...#.#...#u..#...#
###.###.###.###.###.#.#.###.###.###.#.#.#
#...#.....#...#.#.#...#.#.........#.#.#.#
#.###.#######.#.#.#####.#####.#####.#.###
#...#.#...#...#.#.N...#.....#...#...#...#
###.#.#.#.#.###.#.#.#######.###.#.#####.#
#...#...#.#.#...#.#...#...#...#.#.#.#...#
#.###.###.#.###.#.###.#.#.###.###.#.#.#.#
#...#.#...#...#.#..x#...#.#...#...#.#.#.#
###.###.#.###.#.#########.#.###.###.#.#.#
#.#.#...#...#.#...#.......#.........#.#.#
#.#.#.#####.#.###.#.###.#######.#####J#.#
#.#...#...#.#.#.....#.S.#.....#.#.....#.#
#.#####.###.#.###.#####.#.###.###.#######
#...#.......#...#.#...#.#...#...#.......#
###.#.#########.###.#######.###.#.#####.#
#...#.#...#...#...#.........#...#.#.#...#
#.###.#.#.#.#.###.###########.###.#.#.#.#
#.....#.#.#.#...#...........#.#...#.#.#.#
#.#####.#.#.#.#.#########.#.#.#.###.#.###
#.#.....#...#.#.#.....#.#.#.#.#.....#...#
#.###########.#.###.#.#.#.#.#G#########.#
#.#.........#.#.....#.#.#.#.#.....#.....#
#.#.#######.#.#######.#.#.#######.#.###.#
#.#.#...#.#.#.....#.#.#.#.......#.#...#.#
#.#.#.#.#.#.###.#.#.#.#.#######.#.#.#.###
#.#...#.#.#...#.#.#.#.....#.#...#.#.#...#
#.#.###.#.###.#.#.#.#####.#.#.###.#.###P#
#.#...#.#...#.#.#.#.......#.#.....#.#...#
#.#####.#.#.#.###.#.#######.#########.#.#
#...#...#.#.#.#...#...#...#...#.......#.#
###.#.###.###.#.#####.#.#.#.#.###.#####.#
#@....#.........#.......#...#.....#.....#
#########################################'
  end

  def q3
'#########################################
#...........#...K...#.......#.......#..@#
#.#######.###.#.#####.#####.#.###.###.#.#
#p......#.#...#.......#...#.#...#.#...#.#
#######.#.#.###########.#.#.###.#.#.###.#
#y....#.#...#.#.......#.#.#...#.#...#.#.#
#.#.###.#####.#.###.#.#.#.#.#.#.#####.#.#
#.#.#...#...#...#...#.#h#...#.#...#...#.#
#.#.#.###.#.#.###.#####.###.#####.#.###.#
#.#.#.....#.#...#...#...#...#...#...#...#
#M#.#######.###.###.#.###.###.#.#.###.###
#.#.#.....#.#...#...#...#...#.#...#...#.#
#.###.#.#.#.#####.#####.#####.#####.###.#
#...#.#.#.#.....#.....#.#...#.#.....#...#
###.#.#.#.#####.###.#.#.#.#.#.#.#####.#.#
#...#.#.#.....#.....#.#...#...#...#...#.#
#.###O#.#####.#######.#######D###.#.###.#
#.#...#.#.........#.....#...#...#.#...#.#
#.#.###.###########.#####.#.#####.###.#.#
#.#.#.#.#...#.......#.....#.......#...#.#
#.#.#.#.#.#.#.#######.#############.#####
#...#.#...#.#f#.....#.#.......#...#.....#
#.###.#####.#.#####.###.#####.#.#.#####.#
#.#...#..r..#.....#.....#.....#.#.......#
#.###.#V###.#####.#.#####.#####.#######.#
#.#...#...#.....#...#...#...#...#.....#.#
#.#.#####.#####.#####.#.###.###.#.#####.#
#m#.#.....#.#.....R...#..o#.#...#.#...#.#
#.#.#.#####.#.###########.#.#.###.#.#.#.#
#...#.#.......#.....#...#.#.#.#.#...#.#.#
#.###.#######.#.###.###.#.#.#.#.#.###.#.#
#.#...#.....#.#...#...#...#.#.#...#...#.#
#.#.###.###.#####.###.#####.#.#.###.###.#
#.#v#...#.#.....#n..#.#...#.#.#...#.L...#
#.#.#X###.#####.###.#.#.#.#.#.###.#######
#.#...#...Y.#.#.....#s#.#.#...#.#...#...#
#.#####.###.#.#######.#.#.#####.###.###.#
#.#.......#.#.....#.#.#.#.#.......#...#.#
#.#######.#.###.#C#.#.#.#.#.###.#####.#.#
#.........#c....#...#...#.....#.........#
#########################################'
  end

  def q4
'#########################################
#@#.....#.........#.......#.............#
#.#.#.###.#####.###.#.#.###.###########.#
#...#.........#.....#.#.#...#.........#.#
#.###################.###.###.#.###.###.#
#...#...#.#.........#.....#...#...#.#...#
###.#.#.#.#.#######.#.#####.#####.###.#.#
#.#.#.#.#.#.#...#...#.....#.#...#.#...#.#
#.#.#.#.#.#.#.#.###.#####.###.#.#.#.###.#
#.#.#.#...#.#.#...#.....#.#...#...#.#...#
#.#.#.###.#.#.###.#####.#.#.#####.#.#####
#b..#...#.#...#z#.#.....#...#...#.#.....#
#.###.#.#######.#.#####.#####.###.#####.#
#.#...#.........#.....#.#.#.........#...#
#.#####.#######.#####.#.#.#.#######.#.#.#
#.#...#.......#.....#.#.#...#...#...#.#.#
#.#.#.###########.#.#.#.#####.#.#####H#.#
#...#.............#.#.#.......#.#...#.#.#
###.#############.###.#########.#.#.#.#.#
#...#.....#.......#...#.....#.....#...#k#
#.###.###.#########.###.###.###########.#
#.#...#.#.......#...#...#.#...#.....#.#.#
###.###.#######.#.#######.###.#.###.#.#.#
#...#.....#...#...#.........#...#...#.#.#
#.#######.#.#.###.#.#######.#####.###.#.#
#.#.....#.#.#.....#.....#.....#...#.....#
#.#.###.#.#.###########.#.###.#E###.#####
#.#.#...#...#.........#.#.#.#.#.#.#...#.#
#.#.#.#######.#######.#.#.#.#.#.#.###.#.#
#...#.........#...#.#.#.#.#...#.#...#.#.#
###############.#.#.#.#.#.#####.###.#.#.#
#.........#.....#...#.I.#.#.Q.#...#.#...#
#.###.#####.###.###.#####.#.#.###.#.###.#
#...#.#.....#.#.#..j....#...#.#...#...#.#
###.#.#.#####.#.#.###########.#.###.#.#.#
#.#.#...#.....#.#...#.........#...#.#...#
#.#.#####.###.#.#####.###########.#.#####
#...#.....#.#.#.....#..a..........#.W...#
#.###.#####.#U#####.###################.#
#.....#t..........#.....................#
#########################################'
  end

  def part_2
    [q1,q2,q3,q4].map do |inp|
      keys = inp.each_char.select { |c| /[a-z]/ =~ c }.map(&:upcase)
      part_1(inp.each_char.map { |c| /[A-Z]/ =~ c && !keys.include?(c) ? '.' : c }.join)
    end.sum
  end
end

Day18.run if __FILE__ == $0

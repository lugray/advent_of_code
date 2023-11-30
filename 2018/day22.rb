#!/usr/bin/env ruby

require_relative 'day'

class Day22 < Day
  class Cave
    ROCKY = 0
    WET = 1
    NARROW = 2

    attr_reader :target

    def initialize(depth, target)
      @depth = depth
      @target = target
    end

    def type(x, y)
      erosion(x, y) % 3
    end

    def erosion(x, y)
      (geo(x, y) + @depth) % 20183
    end

    def geo(x, y)
      @geo ||= {}
      @geo[[x, y]] ||= begin
        return 0 if x == 0 && y == 0
        return 0 if x == @target[0] && y == @target[1]
        return x * 16807 if y == 0
        return y * 48271 if x == 0
        erosion(x - 1, y) * erosion(x, y - 1)
      end
    end

    def risk
      (0..@target[0]).sum do |x|
        (0..@target[1]).sum do |y|
          type(x, y)
        end
      end
    end

    def valid_tools(x, y)
      case type(x, y)
      when ROCKY
        [TORCH, CLIMBING_GEAR]
      when WET
        [CLIMBING_GEAR, NONE]
      when NARROW
        [TORCH, NONE]
      end
    end

    def valid_tool?(x, y, tool)
      valid_tools(x, y).include?(tool)
    end
  end

  class State
    class << self
      attr_reader :cave

      def set_cave(cave)
        @cave = cave
      end

      def [](x, y, tool, time)
        return nil if x < 0 || y < 0
        return nil if !@cave.valid_tool?(x, y, tool)
        @states ||= {}
        @unvisited ||= {}
        s = @states[[x, y, tool]]
        if s
          if time < s.time
            s.time = time
          end
        else
          s = new(x, y, tool, time)
          @unvisited[[x, y, tool]] = s
          @states[[x, y, tool]] = s
        end
        nil
      end

      def next_state
        @unvisited.values.min_by(&:time).tap do |s|
          @unvisited.delete([s.x, s.y, s.tool])
        end
      end
    end
    attr_reader :x, :y, :tool
    attr_accessor :time

    def initialize(x, y, tool, time)
      @x = x
      @y = y
      @tool = tool
      @time = time
    end

    def calculate_neighbors
      raise 'No time' unless @time
      State[x - 1, y, tool, time + 1]
      State[x + 1, y, tool, time + 1]
      State[x, y - 1, tool, time + 1]
      State[x, y + 1, tool, time + 1]
      State[x, y, TORCH, time + 7]
      State[x, y, CLIMBING_GEAR, time + 7]
      State[x, y, NONE, time + 7]
      nil
    end

    def target?
      x == self.class.cave.target[0] && y == self.class.cave.target[1] && tool == TORCH
    end
  end

  NONE = 0
  TORCH = 1
  CLIMBING_GEAR = 2

  def initialize
    depth, target = input.each_line.map { |line| line.chomp.split(': ').last }
    @depth = depth.to_i
    @target = target.split(',').map(&:to_i)
    @cave = Cave.new(@depth, @target)
  end

  def part_1
    @cave.risk
  end

  def part_2
    State.set_cave(@cave)
    State[0, 0, TORCH, 0]
    state = State.next_state
    until state.target?
      state.calculate_neighbors
      state = State.next_state
    end
    state.time
  end
end

Day22.run if __FILE__ == $0

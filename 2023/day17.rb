#!/usr/bin/env ruby

require_relative 'day'

class Day17 < Day
  UP = 0
  RIGHT = 1
  DOWN = 2
  LEFT = 3
  STATIONARY = Float::INFINITY

  class State
    attr_reader :row, :col, :dir, :count
    attr_accessor :cost

    class << self
      attr_reader :loss, :rows, :cols, :unvisited
      def [](row, col, dir, count)
        @states[[row, col, dir, count]] ||= new(row, col, dir, count).tap { |s| @unvisited[s] = s }
      end

      def loss=(loss)
        @loss = loss
        @states = {}
        @unvisited = {}
        @rows = loss.size
        @cols = loss[0].size
      end

      def next_unvisited
        @unvisited.keys.min_by(&:cost)
      end
    end

    def initialize(row, col, dir, count)
      @row = row
      @col = col
      @dir = dir
      @count = count
      @cost = nil
    end

    def visit!
      State.unvisited.delete(self)
    end

    def compute_neighbors(min_travel = 0, max_travel = 3)
      [
        [row - 1, col, UP],
        [row, col + 1, RIGHT],
        [row + 1, col, DOWN],
        [row, col - 1, LEFT]
      ].each do |r, c, d|
        next if d == (dir + 2) % 4 || ((d-dir) % 4 > 0 && count < min_travel) || (d == dir && count == max_travel) || r < 0 || c < 0 || r >= State.rows || c >= State.cols

        State[r, c, d, d == dir ? count + 1 : 1].tap do |s|
          new_cost = cost + State.loss[r][c]
          s.cost = new_cost if s.cost.nil? || new_cost < s.cost
        end
      end
      nil
    end
  end

  def part_1
    State.loss = input_grid(sep: '', &:to_i)
    state = State[0, 0, STATIONARY, 0].tap { |s| s.cost = 0 }
    until state.row == State.rows - 1 && state.col == State.cols - 1
      state.compute_neighbors
      state.visit!
      state = State.next_unvisited
    end
    state.cost
  end

  def part_2
    State.loss = input_grid(sep: '', &:to_i)
    state = State[0, 0, STATIONARY, 0].tap { |s| s.cost = 0 }
    until state.row == State.rows - 1 && state.col == State.cols - 1
      state.compute_neighbors(4, 10)
      state.visit!
      state = State.next_unvisited
    end
    state.cost
  end
end

Day17.run if __FILE__ == $0

#!/usr/bin/env ruby

require_relative 'day'

class Day21 < Day
  class GameState
    ROLL_SUMS = [1,2,3].repeated_permutation(3).map(&:sum).tally

    attr_reader :pos, :points, :player

    def initialize(pos, points, player)
      @pos = pos
      @points = points
      @player = player % 2
    end

    def hash
      [pos, points, player].hash
    end

    def ==(other)
      pos == other.pos && points == other.points && player == other.player
    end

    def eql?(other)
      self==(other)
    end

    def won?
      @points.any? { |p| p >= 21 }
    end

    def winner
      (@player+1) % 2
    end

    def next_states
      return { self => 1 } if won?
      ROLL_SUMS.each_with_object(Hash.new { 0 }) do |(move, count), h|
        pos = @pos.dup
        points = @points.dup
        pos[@player] = ((pos[@player] + move) % 10).nonzero? || 10
        points[@player] += pos[@player]
        h[GameState.new(pos, points, @player + 1)] += count
      end
    end
  end

  def initialize
    @pos = [1, 10]
  end

  def part_1
    player, next_player = 0, 1
    pos = @pos
    points = [0, 0]
    (1..100).cycle.each_slice(3).lazy.map(&:sum).each_with_index do |move, count|
      pos[player] = ((pos[player] + move) % 10).nonzero? || 10
      points[player] += pos[player]
      if points[player] >= 1000
        return points[next_player] * (count+1) * 3
      end

      player, next_player = next_player, player
    end
  end

  def part_2
    states = {
      GameState.new(@pos, [0, 0], 0) => 1,
    }
    until states.all? { |state, _| state.won? }
      states = states.each_with_object(Hash.new { 0 }) do |(state, count), h|
        state.next_states.each do |ns, nc|
          h[ns] += count * nc
        end
      end
    end

    states.each_with_object(Hash.new { 0 }) do |(state, count), h|
      h[state.winner] += count
    end.values.max
  end
end

Day21.run if __FILE__ == $0

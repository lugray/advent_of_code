#!/usr/bin/env ruby

class Circle
  attr_reader :value

  def initialize(value)
    @value = value
    @cw = self
    @cc = self
  end

  def insert(value)
    to_insert = Circle.new(value)
    after = @cw
    @cw = to_insert
    to_insert.cc = self
    to_insert.cw = after
    after.cc = to_insert
    to_insert
  end

  def remove
    after = @cw
    before = @cc
    after.cc = before
    before.cw = after
    @cc = nil
    @cw = nil
    @value
  end

  def clockwise(n = 1)
    ret = self
    n.times do
      ret = ret.cw
    end
    ret
  end

  def counter_clockwise(n = 1)
    ret = self
    n.times do
      ret = ret.cc
    end
    ret
  end

  def to_a
    arr = [self.value]
    cur = cw
    while cur != self do
      arr << cur.value
      cur = cur.cw
    end
    arr
  end

  protected

  attr_accessor :cw, :cc
end

class Game
  def initialize(player_count, max_marble)
    @player_count = player_count
    @max_marble = max_marble
    @zero = @current = Circle.new(0)
    @scores = Hash.new(0)
  end

  def play(verbose: false)
    (1..@max_marble). each do |i|
      turn(i)
      puts self if verbose
    end
    self
  end

  def max_score
    @scores.values.max
  end

  def to_s
    @zero.to_a.map{|v| v == @current.value ? "(#{v})" : "#{v}"}.join(" ")
  end

  private

  def turn(value)
    if value % 23 == 0
      player = value % @player_count
      @scores[player] += value + @current.counter_clockwise(7).remove
      @current = @current.counter_clockwise(6)
    else
      @current = @current.clockwise.insert(value)
    end
  end
end

puts Game.new(9, 25).play(verbose: true).max_score
puts Game.new(405, 71700).play.max_score
puts Game.new(405, 7170000).play.max_score

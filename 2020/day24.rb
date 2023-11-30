#!/usr/bin/env ruby

require_relative 'day'

class Day24 < Day
  class Address
    def self.from_instruction(instruction)
      new.tap { |a| a.move(instruction) }
    end

    attr_reader :e, :ne

    def initialize(e = 0, ne = 0)
      @e = e
      @ne = ne
    end

    def move(instruction)
      instruction.scan(/e|se|sw|w|nw|ne/) do |part|
        case part
        when 'e' then @e += 1
        when 'w' then @e -= 1
        when 'ne' then @ne += 1
        when 'sw' then @ne -= 1
        when 'se' then @e += 1; @ne -= 1
        when 'nw' then @e -= 1; @ne += 1
        end
      end
    end

    def neighbors
      ['e', 'w', 'ne', 'nw', 'se', 'sw'].map { |instruction| dup.tap { |a| a.move(instruction) } }
    end

    def dup
      self.class.new(@e, @ne)
    end

    def ==(other)
      @e == other.e && @ne == other.ne
    end
    alias_method :eql?, :==

    def hash
      [@e, @ne].hash
    end
  end

  def initialize
    @instructions = input_lines
  end

  def part_1
    @instructions.map { |instruction| Address.from_instruction(instruction) }.tally.select { |_, v| v.odd? }.size
  end

  def part_2
    black_tiles = @instructions.map { |instruction| Address.from_instruction(instruction) }.tally.select { |_, v| v.odd? }.keys.to_set
    100.times do
      neighbors = black_tiles.flat_map { |tile| tile.neighbors }.to_set
      next_black_tiles = black_tiles.dup
      (neighbors + black_tiles).each do |tile|
        black_neighbors = tile.neighbors.count { |neighbor| black_tiles.include?(neighbor) }
        if black_tiles.include?(tile)
          next_black_tiles.delete(tile) if black_neighbors == 0 || black_neighbors > 2
        else
          next_black_tiles << tile if black_neighbors == 2
        end
      end
      black_tiles = next_black_tiles
    end
    black_tiles.count
  end
end

Day24.run if __FILE__ == $0

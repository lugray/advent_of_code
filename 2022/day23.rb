#!/usr/bin/env ruby

require_relative 'day'
require 'matrix'

class Day23 < Day
  class Elf
    N_SPLAY = [Vector[0, -1], Vector[-1, -1], Vector[1, -1]]
    S_SPLAY = [Vector[0, 1], Vector[-1, 1], Vector[1, 1]]
    W_SPLAY = [Vector[-1, 0], Vector[-1, -1], Vector[-1, 1]]
    E_SPLAY = [Vector[1, 0], Vector[1, -1], Vector[1, 1]]
    SPLAYS = [N_SPLAY, S_SPLAY, W_SPLAY, E_SPLAY]
    SURROUNDING = SPLAYS.flatten(1).uniq

    attr_reader :pos

    def initialize(pos)
      @pos = pos
    end

    def x
      @pos[0]
    end
    
    def y
      @pos[1]
    end
    
    def propose(map, proposals)
      return unless SURROUNDING.any? { |v| map[@pos + v] }
      dir = SPLAYS.find do |splay|
        splay.all? { |v| map[@pos + v].nil? }
      end&.first
      return unless dir
      if proposals[@pos + dir].nil?
        proposals[@pos + dir] = self
      else
        proposals[@pos + dir] = false
      end
    end
  end

  def initialize
    @map = input.each_line(chomp: true).each_with_object({}).with_index do |(line, h), y|
      line.each_char.with_index do |char, x|
        next unless char == '#'
        pos = Vector[x, y]
        h[pos] = Elf.new(pos)
      end
    end
    @round = 0
  end
  
  def empty_in_rect
    minx, maxx = @map.values.map(&:x).minmax
    miny, maxy = @map.values.map(&:y).minmax
    (maxx - minx + 1) * (maxy - miny + 1) - @map.size
  end

  def do_round
    @round += 1
    proposals = {}
    @map.each_value do |elf|
      elf.propose(@map, proposals)
    end
    return false if proposals.empty?
    proposals.each do |pos, elf|
      next unless elf
      @map.delete(elf.pos)
      @map[pos] = Elf.new(pos)
    end
    Elf::SPLAYS.push(Elf::SPLAYS.shift)
    true
  end

  def part_1
    10.times do
      break unless do_round
    end
    empty_in_rect
  end

  def part_2
    while do_round
    end
    @round
  end
end

Day23.run if __FILE__ == $0

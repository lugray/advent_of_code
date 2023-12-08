#!/usr/bin/env ruby

require_relative 'day'

class Day08 < Day
  class Node
    class << self
      def [](val)
        @nodes ||= {}
        @nodes[val] ||= new(val)
      end

      def nodes
        @nodes ||= {}
        @nodes.values
      end
    end

    attr_reader :val
    attr_accessor :left, :right

    def initialize(val)
      @val = val
    end

    def to_s
      "#{val} (#{left&.val}, #{right&.val})"
    end

    def inspect
      "<Node #{to_s}>"
    end
  end

  def initialize
    directions, nodes = input_paragraphs
    @directions = directions.chomp.each_char.cycle
    nodes.lines(chomp: true).each do |line|
      current, dest = line.split(' = ')
      l, r = dest.tr('()', '').split(', ')
      Node[current].left = Node[l]
      Node[current].right = Node[r]
    end
  end

  def go(from: 'AAA', to: ->(n) { n.val == 'ZZZ' })
    n = Node[from]
    i = 0
    while dir = @directions.next
      case dir
      when 'L' then n = n.left
      when 'R' then n = n.right
      end
      i += 1
      break if to.call(n)
    end
    [i, n]
  end

  def part_1
    go.first
  end

  def part_2
    @directions.rewind
    nodes = Node.nodes.select { |n| n.val.end_with?('A') }
    raise unless nodes.all? do |n|
      i, n2 = go(from: n.val, to: ->(n) { n.val.end_with?('Z') })
      i2, n3 = go(from: n2.val, to: ->(n) { n.val.end_with?('Z') })
      i == i2 && n3.val == n2.val
    end
    @directions.rewind
    cycle_sizes = nodes.map do |n|
      go(from: n.val, to: ->(n) { n.val.end_with?('Z') }).first
    end
    lcm = cycle_sizes.reduce(1, :lcm)
  end
end

Day08.run if __FILE__ == $0

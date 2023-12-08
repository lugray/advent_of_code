#!/usr/bin/env ruby

require_relative 'day'

class Day08 < Day
  class Node < Struct.new(:val, :l, :r)
    @nodes = {}

    class << self
      include Enumerable
      def each(&block) = @nodes.values.each(&block)

      def [](val)
        @nodes[val] ||= new(val)
      end
    end
  end

  def initialize
    directions, nodes = input_paragraphs
    @directions = directions.chomp.downcase.each_char
    nodes.lines(chomp: true).each do |line|
      current, dests = line.split(' = ')
      l, r = dests.tr('()', '').split(', ')
      Node[current].l = Node[l]
      Node[current].r = Node[r]
    end
  end

  def part_1(node: Node['AAA'], to: 'ZZZ')
    @directions.cycle.find_index do |dir|
      node = node.public_send(dir)
      to === node.val
    end + 1
  end

  def part_2
    Node.select { |n| n.val.end_with?('A') }.reduce(1) do |lcm, node|
      lcm.lcm(part_1(node:, to: /Z$/))
    end
  end
end

Day08.run if __FILE__ == $0

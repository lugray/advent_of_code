#!/usr/bin/env ruby

require_relative 'day'

class Day20 < Day
  class Cycle
    class Node
      attr_accessor :val, :next, :prev

      def initialize(val)
        @val = val
      end

      def relative(n)
        ret = self
        if n > 0
          n.times { ret = ret.next }
        else
          (-n).times { ret = ret.prev }
        end
        ret
      end
    end

    def initialize(vals)
      @nodes = vals.map { |val| Node.new(val) }
      @size = @nodes.size
      @zero = @nodes.find { |node| node.val == 0 }
      @nodes.each_cons(2) { |a, b| join(a, b) }
      join(@nodes.last, @nodes.first)
    end

    def [](n)
      @zero.relative(normalize(n)).val
    end

    def mix
      @nodes.each do |node|
        delete(node)
        insert_after(node.prev.relative(normalize(node.val)), node)
      end
      self
    end

    private

    def insert_after(prev, new_node)
      join(new_node, prev.next)
      join(prev, new_node)
      @size += 1
    end

    def delete(node)
      join(node.prev, node.next)
      @size -= 1
    end

    def join(n1, n2)
      n1.next = n2
      n2.prev = n1
    end

    def normalize(n)
      dist = n % @size
      if dist > @size / 2
        dist = dist - @size
      end
      dist
    end
  end

  def initialize
    @vals = input_lines
  end

  def part_1
    cycle = Cycle.new(@vals).mix
    [cycle[1000], cycle[2000], cycle[3000]].sum
  end

  def part_2
    cycle = Cycle.new(@vals.map { |val| val * 811589153 })
    10.times { cycle.mix }
    [cycle[1000], cycle[2000], cycle[3000]].sum
  end
end

Day20.run if __FILE__ == $0

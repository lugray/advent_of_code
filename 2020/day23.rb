#!/usr/bin/env ruby

require_relative 'day'

class Day23 < Day
  class Cycle
    class Node
      attr_reader :value
      attr_accessor :next, :prev

      def initialize(value)
        @value = value
      end

      def to_a
        a = [self.value]
        n = self.next
        while n && n != self
          a << n.value
          n = n.next
        end
        a
      end

      def first(count)
        a = [self.value]
        n = self.next
        while n && n != self && a.size < count
          a << n.value
          n = n.next
        end
        a
      end

      def include?(value)
        n = self
        loop do
          return true if n.value == value
          n = n.next
          break if !n || n == self
        end
        false
      end
    end

    def initialize(cups)
      cup_nodes = cups.map { |c| Node.new(c) }
      cup_nodes.each_cons(2) { |a, b| a.next = b; b.prev = a }
      cup_nodes.first.prev = cup_nodes.last
      cup_nodes.last.next = cup_nodes.first
      @current = cup_nodes.first
      @min = cups.min
      @max = cups.max
      @cups = cup_nodes.each_with_object({}) { |cn, h| h[cn.value] = cn }
    end

    def find(value)
      @cups[value]
    end

    def take_3
      s = @current.next
      e = s.next.next
      post_end = e.next
      s.prev = nil
      e.next = nil
      @current.next = post_end
      post_end.prev = @current
      s
    end

    def next_candidate(cur_val)
      d_val = cur_val - 1
      d_val = @max if d_val < @min
      d_val
    end

    def dest(trio)
      d_val = next_candidate(@current.value)
      until !trio.include?(d_val) do
        d_val = next_candidate(d_val)
      end
      find(d_val)
    end

    def move
      trio = take_3
      d = dest(trio)
      trio_last = trio.next.next
      trio_last.next = d.next
      d.next.prev = trio_last
      d.next = trio
      trio.prev = d
      @current = @current.next
    end

    def first(count)
      @current.first(count)
    end
  end

  def initialize
    @input = input.chomp.each_char.map(&:to_i)
  end

  def part_1
    cycle = Cycle.new(@input)
    100.times { cycle.move }
    cycle.find(1).to_a[1..].join
  end

  def part_2
    input = @input + (10..1_000_000).to_a
    cycle = Cycle.new(input)
    10_000_000.times { cycle.move }
    cycle.find(1).first(3)[1..].inject(:*)
  end
end

Day23.run if __FILE__ == $0

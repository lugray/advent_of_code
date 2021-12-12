#!/usr/bin/env ruby

require_relative 'day'

class Day12 < Day
  class Path
    def initialize(connections, nodes = ['start'], has_revisit = false)
      @connections = connections
      @nodes = nodes
      @has_revisit = has_revisit || last_is_revisit?
    end

    def last_is_revisit?
      small?(@nodes.last) && @nodes[0..-2].include?(@nodes.last)
    end

    def small?(node)
      node.downcase == node
    end

    def next_valids(revist_once)
      @connections[@nodes.last].reject do |node|
        if revist_once
          node == 'start' || (@has_revisit && small?(node) && @nodes.include?(node))
        else
          small?(node) && @nodes.include?(node)
        end
      end
    end

    def extensions(revist_once = false)
      return self if done?
      next_valids(revist_once).map { |n| Path.new(@connections, @nodes + [n], @has_revisit) }
    end

    def extensions_with_revisit
      extensions(true)
    end

    def done?
      @nodes.last == 'end'
    end

    def to_s
      @nodes.join(',')
    end
  end

  def initialize
    @connections = input_lines.each_with_object({}) do |line, h|
      a, b = line.split('-')
      h[a] ||= []
      h[b] ||= []
      h[a] << b
      h[b] << a
    end
  end

  def part_1
    paths = [Path.new(@connections)]
    until paths.all?(&:done?)
      paths = paths.flat_map(&:extensions)
    end
    paths.count
  end

  def part_2
    paths = [Path.new(@connections)]
    until paths.all?(&:done?)
      paths = paths.flat_map(&:extensions_with_revisit)
    end
    paths.count
  end

  def input
    return super
    <<~I
start-A
start-b
A-c
A-b
b-d
A-end
b-end
    I
  end
end

Day12.run if __FILE__ == $0

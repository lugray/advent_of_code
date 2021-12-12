#!/usr/bin/env ruby

require_relative 'day'

class Day12 < Day
  class Path
    def initialize(connections, nodes: ['start'], allow_revisit: false)
      @connections = connections
      @nodes = nodes
      @allow_revisit = allow_revisit
    end

    def next_valids
      @connections[@nodes.last].reject do |node|
        (!@allow_revisit && is_revisit?(node)) || node == 'start'
      end
    end

    def extensions
      return [self] if done?
      next_valids.flat_map { |n| extend_by(n).extensions }
    end

    def extend_by(node)
      Path.new(@connections, nodes: @nodes + [node], allow_revisit: @allow_revisit && !is_revisit?(node))
    end

    def is_revisit?(node)
      node.downcase == node && @nodes.include?(node)
    end

    def done?
      @nodes.last == 'end'
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
    Path.new(@connections).extensions.count
  end

  def part_2
    Path.new(@connections, allow_revisit: true).extensions.count
  end
end

Day12.run if __FILE__ == $0

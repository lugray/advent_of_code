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

    def next_valids(with_one_revisit:)
      @connections[@nodes.last].reject do |node|
        if with_one_revisit
          node == 'start' || (@has_revisit && small?(node) && @nodes.include?(node))
        else
          small?(node) && @nodes.include?(node)
        end
      end
    end

    def extensions(with_one_revisit: false)
      return [self] if done?
      next_valids(with_one_revisit: with_one_revisit).flat_map do |n|
        Path.new(@connections, @nodes + [n], @has_revisit).extensions(with_one_revisit: with_one_revisit)
      end
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
    Path.new(@connections).extensions(with_one_revisit: true).count
  end
end

Day12.run if __FILE__ == $0

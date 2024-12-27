#!/usr/bin/env ruby

require_relative 'day'

class Day23 < Day
  def initialize
    @connections = input_lines.each_with_object(Hash.new { |h, k| h[k] = Set.new }) do |line, hash|
      a, b = line.split('-')
      hash[a] << b
      hash[b] << a
    end
  end

  def part_1
    seen = Set.new
    @connections.keys.sum do |node|
      next 0 unless node.start_with?('t')
      seen << node
      @connections[node].to_a.combination(2).count do |a, b|
        next false if seen.include?(a) || seen.include?(b)
        @connections[a].include?(b)
      end
    end
  end

  def part_2
    (@connections.values.map(&:size).max+1).downto(1) do |size|
      @connections.each do |node, set|
        (set.to_a << node).combination(size).each do |comb|
          return comb.sort.join(',') if comb.combination(2).all? { |a, b| @connections[a].include?(b) }
        end
      end
    end
  end
end

Day23.run if __FILE__ == $0

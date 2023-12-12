#!/usr/bin/env ruby

require_relative 'day'

class Day12 < Day
  def candidates(str, group_sum)
    return enum_for(:candidates, str, group_sum) unless block_given?
    i = str.index('?')
    return yield str unless i

    tallies = str.each_char.tally
    if tallies.fetch('#', 0) + tallies.fetch('?', 0) == group_sum
      return yield str.gsub('?', '#')
    elsif tallies['#'] == group_sum
      return yield str.gsub('?', '.')
    end

    candidates(str.sub('?', '.'), group_sum) { |s| yield s }
    candidates(str.sub('?', '#'), group_sum) { |s| yield s }
  end

  def groups_from(str)
    str.split(/\.+/).reject(&:empty?).map(&:length)
  end

  def initialize
    @rows = input_grid
  end

  def part_1
    @rows.sum do |conditions, groups|
      groups = groups.split(',').map(&:to_i)
      candidates(conditions, groups.sum).count { |c| groups_from(c) == groups }
    end
  end

  def part_2
  end
end

Day12.run if __FILE__ == $0

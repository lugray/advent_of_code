#!/usr/bin/env ruby

require_relative 'day'

class Day12 < Day
  def initialize
    @rows = input_grid
    @count_possibilities = {}
  end

  def count_possibilities(conditions, groups)
    @count_possibilities[[conditions, groups]] ||= count_possibilities!(conditions, groups)
  end

  def fast_zero?(conditions, groups)
    @count_possibilities[[conditions, groups]] == 0
  end

  def medium_zero?(conditions, groups)
    case @count_possibilities[[conditions, groups]]
    when 0
      true
    when nil
      if medium_zero!(conditions, groups)
        @count_possibilities[[conditions, groups]] = 0
        true
      else
        @count_possibilities[[conditions, groups]] = false # Memoize non-medium zero so we can answer more quickly next time, but still allow overwriting the full calculation
        false
      end
    else
      false
    end
  end

  def medium_zero!(conditions, groups)
    gs = groups.sum
    (cc = conditions.count('#')) > gs || cc + conditions.count('?') < gs
  end

  def count_possibilities!(conditions, groups)
    if groups.empty?
      return conditions.count('#') == 0 ? 1 : 0
    end

    lg = groups.max
    lgi = groups.index(lg)

    (0..(conditions.size - lg)).sum do |i|
      next 0 unless i == 0 || conditions[i-1] != '#'
      next 0 unless i + lg == conditions.size || conditions[i+lg] != '#'
      next 0 unless conditions[i...(i+lg)].each_char.none? { |c| c == '.' }

      right_args = [conditions[i+lg+1..] || '', groups[(lgi+1)..]]
      left_args = [conditions[...[i-1,0].max], groups[...lgi]]
      next 0 if fast_zero?(*right_args) || fast_zero?(*left_args) || medium_zero?(*right_args) || medium_zero?(*left_args)
      right = count_possibilities(*right_args)
      next 0 if right == 0
      left = count_possibilities(*left_args)
      left * right
    end
  end

  def part_1
    @rows.sum do |conditions, groups|
      groups = groups.split(',').map(&:to_i)
      count_possibilities(conditions, groups)
    end
  end

  def part_2
    @rows.sum do |conditions, groups|
      groups = groups.split(',').map(&:to_i)
      conditions = ([conditions]*5).join('?')
      groups = groups * 5
      count_possibilities(conditions, groups)
    end
  end
end

Day12.run if __FILE__ == $0

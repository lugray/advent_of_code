#!/usr/bin/env ruby

require_relative 'day'

class BugLife
  def initialize(layout)
    @layout = layout
  end

  def count_around(i)
    [i % 5 == 0 ? nil : i - 1, i % 5 == 4 ? nil : i + 1, i - 5, i + 5].count { |n| n && n >= 0 && @layout[n] }
  end
  
  def step
    @layout = @layout.each_with_index.map do |c, i|
      if c
        count_around(i) == 1
      else
        [1, 2].include?(count_around(i))
      end
    end
  end

  def repeat_biodiversity
    biodiversities = {}
    loop do
      b = biodiversity
      return b if biodiversities.key?(b)
      biodiversities[b] = nil 
      step
    end
  end

  def biodiversity
    @layout.each_with_index.sum do |c, i|
      c ? 2 ** i : 0
    end
  end

  def to_s
    @layout.map { |c| c ? '#' : '.' }.each_slice(5).map(&:join).join("\n")
  end
end

class NilClass
  def [](k)
    nil
  end
end

class RecursiveBugLife
  def initialize(layout)
    @layout = { 0 => layout.each_with_index.to_a.map(&:reverse).to_h }
  end

  def bug_count
    @layout.values.sum { |l| l.values.count(&:itself) }
  end

  def count_around(level, i)
    count_left(level, i) + count_right(level, i) + count_up(level, i) + count_down(level, i)
  end

  def count_left(level, i)
    if i == 13
      [@layout[level + 1][4], @layout[level + 1][9], @layout[level + 1][14], @layout[level + 1][19], @layout[level + 1][24]].count(&:itself)
    elsif i % 5 == 0
      @layout[level - 1][11] ? 1 : 0
    else
      @layout[level][i - 1] ? 1 : 0
    end
  end

  def count_right(level, i)
    if i == 11
      [@layout[level + 1][0], @layout[level + 1][5], @layout[level + 1][10], @layout[level + 1][15], @layout[level + 1][20]].count(&:itself)
    elsif i % 5 == 4
      @layout[level - 1][13] ? 1 : 0
    else
      @layout[level][i + 1] ? 1 : 0
    end
  end

  def count_up(level, i)
    if i == 17
      [@layout[level + 1][20], @layout[level + 1][21], @layout[level + 1][22], @layout[level + 1][23], @layout[level + 1][24]].count(&:itself)
    elsif i < 5
      @layout[level - 1][7] ? 1 : 0
    else
      @layout[level][i - 5] ? 1 : 0
    end
  end

  def count_down(level, i)
    if i == 7
      [@layout[level + 1][0], @layout[level + 1][1], @layout[level + 1][2], @layout[level + 1][3], @layout[level + 1][4]].count(&:itself)
    elsif i > 19
      @layout[level - 1][17] ? 1 : 0
    else
      @layout[level][i + 5] ? 1 : 0
    end
  end

  def step
    new_layout = @layout.dup.transform_values(&:dup)
    (@layout.keys.min-1..@layout.keys.max+1).each do |level|
      # new_layout[level] ||= (0...25).zip([0].cycle).to_h
      (0...25).each do |i|
        # new_layout[level][i] = count_around(level, i)
        next if i == 12
        if @layout[level][i]
          if count_around(level, i) != 1
            new_layout[level] ||= (0...25).zip([false].cycle).to_h
            new_layout[level][i] = false
          end
        else
          if [1, 2].include?(count_around(level, i))
            new_layout[level] ||= (0...25).zip([false].cycle).to_h
            new_layout[level][i] = true
          end
        end
      end
    end
    @layout = new_layout
  end
end

class Day24 < Day
  def part_1
    BugLife.new(input.each_line.map(&:chomp).join.each_char.map { |c| c == '#' }).repeat_biodiversity
  end

  def part_2
    bl = RecursiveBugLife.new(input.each_line.map(&:chomp).join.each_char.map { |c| c == '#' })
    200.times { bl.step }
    bl.bug_count
  end
end

Day24.run if __FILE__ == $0

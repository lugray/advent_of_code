#!/usr/bin/env ruby

require_relative 'day'

class Day04 < Day
  def part_1
    input_lines.sum do |line|
      _, nums = line.split(': ')
      win, have = nums.split(' | ')
      win = win.split(' ').map(&:to_i)
      have = have.split(' ').map(&:to_i)
      c = have.count { |n| win.include?(n) }
      c == 0 ? 0 : 2**(c - 1)
    end
  end

  def part_2
    card_counts = Hash.new(0)
    input_lines.each do |line|
      card, nums = line.split(': ')
      card_num = card.split(' ').last.to_i
      card_counts[card_num] += 1
      win, have = nums.split(' | ')
      win = win.split(' ').map(&:to_i)
      have = have.split(' ').map(&:to_i)
      c = have.count { |n| win.include?(n) }
      ((card_num+1)..card_num+c).each do |n|
        card_counts[n] += card_counts[card_num]
      end
    end
    card_counts.values.sum
  end
end

Day04.run if __FILE__ == $0

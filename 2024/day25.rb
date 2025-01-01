#!/usr/bin/env ruby

require_relative 'day'

class Day25 < Day
  def initialize
    @keys = []
    @locks = []
    input_paragraphs.each do |paragraph|
      lines = paragraph.lines { |line| line.each_char.to_a }
      if lines.first.all? { |c| c == '#' }
        @locks << lines.transpose.map { |col| col.count('.') }
      else
        @keys << lines.transpose.map { |col| col.count('#') }
      end
    end
  end

  def part_1
    @locks.sum do |lock|
      @keys.count do |key|
        key.zip(lock).all? { |k, l| l >= k }
      end
    end
  end

  def part_2
  end
end

Day25.run if __FILE__ == $0

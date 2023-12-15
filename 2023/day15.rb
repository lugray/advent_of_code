#!/usr/bin/env ruby

require_relative 'day'

class String
  def hsh = each_char.inject(0) { |acc, c| (acc + c.ord) * 17 % 256 }
end

class Day15 < Day
  Lens = Struct.new(:label, :focal, keyword_init: true)

  class Box
    def focus_power = @lenses.each_with_index.sum { |lens, j| (j+1) * lens.focal }
    def initialize = @lenses = []
    def remove(label) = @lenses.delete_if { |lens| lens.label == label }

    def place(lens)
      if existing = @lenses.find { |l| l.label == lens.label }
        existing.focal = lens.focal
      else
        @lenses << lens
      end
    end
  end

  def initialize = @seq = input_grid(sep: ',').first
  def part_1 = @seq.sum(&:hsh)
  def part_2 = init(@seq).each_with_index.sum { |box, i| (i+1) * box.focus_power }

  def init(seq)
    Array.new(256) { Box.new }.tap do |boxes|
      seq.each do |s|
        label, focal = s.split(/[-=]/).map(&:to_i_if_i)
        box = boxes[label.hsh]
        case s
        when /-/ then box.remove(label)
        when /=/ then box.place(Lens.new(label:, focal:))
        end
      end
    end
  end
end

Day15.run if __FILE__ == $0

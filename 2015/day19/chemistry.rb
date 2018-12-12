#!/usr/bin/env ruby

class Chemistry
  def initialize(input)
    lines = input.each_line.map(&:chomp).reject(&:empty?)
    @molecule = lines.pop
    @replacements = lines.map do |line|
      line.split(' => ')
    end
  end

  def count_distinct
    @replacements.flat_map do |from, to|
      parts = @molecule.split(from, @molecule.length)
      (1...parts.length).map do |i|
        parts[0...i].join(from) + to + parts[i..-1].join(from)
      end
    end.uniq.count
  end

  def steps
    steps_for(@molecule, 0)
  end

  private

  def steps_for(molecule, n)
    return n if molecule == 'e'
    p = precursors(molecule).sort_by(&:length)
    return nil if p.empty?
    p.each do |m|
      s = steps_for(m, n + 1)
      return s if s
    end
  end

  def precursors(molecule)
    @replacements.flat_map do |to, from|
      parts = molecule.split(from, molecule.length+1)
      next unless parts.length > 1
      (1...parts.length).map do |i|
        parts[0...i].join(from) + to + parts[i..-1].join(from)
      end
    end.compact.uniq
  end
end

input = 'H => HO
H => OH
O => HH
e => H
e => O

HOHOHO
'
input = File.read('input')

puts Chemistry.new(input).count_distinct
puts Chemistry.new(input).steps

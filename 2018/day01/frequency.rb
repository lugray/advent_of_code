#!/usr/bin/env ruby
class Frequency
  def initialize(lines)
    @deltas = lines.map(&:to_i)
  end

  def final
    @deltas.sum
  end

  def first_duplicate
    current = 0
    seen = {}
    @deltas.cycle do |delta|
      current += delta
      return current if seen[current]
      seen[current] = true
    end
  end
end

freq = Frequency.new(File.read('input').lines.map(&:chomp))
puts freq.final
puts freq.first_duplicate

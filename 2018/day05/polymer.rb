#!/usr/bin/env ruby

class Polymer
  def initialize(str)
    @str = str
  end

  def shrunk(without = nil)
    shrunk = []
    @str.each_char do |c|
      next if without && c.downcase == without.downcase
      if opposites?(shrunk.last, c)
        shrunk.pop
      else
        shrunk.push(c)
      end
    end
    shrunk.join
  end

  def best_shrink
    ('a'..'z').map do |without|
      shrunk(without)
    end.min_by(&:length)
  end

  def opposites?(a, b)
    return false unless a.respond_to?(:downcase)
    return false unless b.respond_to?(:downcase)
    a.downcase == b.downcase && a != b
  end
end

input = 'dabAcCaCBAcCcaDA'
input = File.read('input').chomp
polymer = Polymer.new(input)
puts polymer.shrunk.length
puts polymer.best_shrink.length

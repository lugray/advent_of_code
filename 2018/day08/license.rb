#!/usr/bin/env ruby

class Node
  def self.from_string(input)
    Node.new(input.chomp.split(' ').map(&:to_i))
  end

  def initialize(arr)
    child_count = arr.shift
    metadata_count = arr.shift
    @children = []
    child_count.times do
      @children << Node.new(arr)
    end
    @metadata = arr.shift(metadata_count)
  end

  def metadata_sum
    @metadata.sum + @children.map(&:metadata_sum).sum
  end

  def value
    return @metadata.sum if @children.empty?
    @children.values_at(*@metadata.map { |m| m - 1 if m > 0 }.compact).compact.map(&:value).sum
  end
end

input = '2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
'
input = File.read('input')
license = Node.from_string(input)
puts license.metadata_sum
puts license.value

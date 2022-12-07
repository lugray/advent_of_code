#!/usr/bin/env ruby

require_relative 'day'

FileEntry = Struct.new(:name, :size)

class Directory
  @dirs = Hash.new { |h, k| h[k] = Directory.new(k) }

  class << self
    include Enumerable

    def [](name) = @dirs[name]
    def each(&block) = @dirs.values.each(&block)
  end

  def initialize(name)
    @name = name
    @children = {}
  end

  attr_reader :name
  def <<(child) = @children[child.name] = child
  def size = @children.values.sum(&:size)
  def expand_path(path) = File.expand_path(path, name)
end

class Day07 < Day
  def initialize
    current = Directory['/']
    input.each_line(chomp: true) do |line|
      case line.split(' ')
        in ['$', 'ls']      ; # Ignore
        in ['$', 'cd', dir] ; current = Directory[current.expand_path(dir)]
        in ['dir', dir]     ; current << Directory[current.expand_path(dir)]
        in [size, file]     ; current << FileEntry.new(current.expand_path(file), size.to_i)
      end
    end
  end

  def part_1
    Directory.select { |d| d.size <= 100000 }.sum(&:size)
  end

  def part_2
    needed = 30000000 - (70000000 - Directory['/'].size)
    Directory.select { |d| d.size >= needed }.min_by(&:size).size
  end
end

Day07.run if __FILE__ == $0

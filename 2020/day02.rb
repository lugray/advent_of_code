#!/usr/bin/env ruby

require_relative 'day'

class Password
  def initialize(string)
    md = string.match(/(\d+)-(\d+) (\w): (.+)/)
    raise "Bad value: #{string}" unless md
    @min = md[1].to_i
    @max = md[2].to_i
    @char = md[3]
    @pass = md[4]
  end

  def valid?
    @pass.count(@char).between?(@min, @max)
  end

  def new_valid?
    (@pass[@min-1] == @char) ^ (@pass[@max-1] == @char)
  end
end

class Day02 < Day
  def initialize
    @passwords = input.lines.map { |line| Password.new(line) }
  end

  def part_1
    @passwords.count(&:valid?)
  end

  def part_2
    @passwords.count(&:new_valid?)
  end
end

Day02.run if __FILE__ == $0

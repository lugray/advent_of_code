#!/usr/bin/env ruby

require_relative 'day'

class SpeakNumbers
  def initialize(starting_numbers)
    @history = {}
    @turn = 0
    starting_numbers.split(',').each do |n|
      speak(n.to_i)
    end
  end

  def turn(n)
    until @turn == n do
      speak
    end
    @last_number
  end

  def speak(number = nil)
    number ||= next_number
    @history[@last_number] = @turn
    @turn += 1
    @last_number = number
  end

  def next_number
    @turn - @history.fetch(@last_number, @turn)
  end
end

class Day15 < Day
  def initialize
    @speak_numbers = SpeakNumbers.new(input)
  end

  def part_1
    @speak_numbers.turn(2020)
  end

  def part_2
    @speak_numbers.turn(30000000)
  end
end

Day15.run if __FILE__ == $0

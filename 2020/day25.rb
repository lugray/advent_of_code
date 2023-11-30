#!/usr/bin/env ruby

require_relative 'day'

class Day25 < Day
  def initialize
    @public_keys = input_lines
  end

  def transform_once(subject_number, value)
    value *= subject_number
    value %= 20201227
    value
  end

  def transform(subject_number, loop_size)
    value = 1
    loop_size.times { value = transform_once(subject_number, value) }
    value
  end

  def loop_size(public_keys)
    value = 1
    loop_size = 0
    until public_keys.include?(value)
      value = transform_once(7, value)
      loop_size += 1
    end
    [loop_size, public_keys.index(value)]
  end

  def part_1
    ls, id = loop_size(@public_keys)
    transform(@public_keys[1-id], ls)
  end

  def part_2
  end
end

Day25.run if __FILE__ == $0

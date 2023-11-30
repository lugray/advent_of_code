#!/usr/bin/env ruby

require_relative 'day'

class Day25 < Day
  def initialize
    prelude, *states = input.split("\n\n")
    @initial_state = prelude.scan(/Begin in state (\w)/).first.first
    @steps = prelude.scan(/Perform a diagnostic checksum after (\d+) steps/).first.first.to_i
    @states = states.each_with_object({}) do |state, h|
      state_lines = state.split("\n")
      name = state.scan(/In state (\w)/).first.first
      h[name] = state.split("If the current value is 1:\n").map do |s|
        [
          s.scan(/- Write the value (\d)/).first.first.to_i,
          s.scan(/- Move one slot to the (\w+)/).first.first == 'right' ? 1 : -1,
          s.scan(/- Continue with state (\w)/).first.first,
        ]
      end
    end
  end

  def part_1
    tape = Hash.new(0)
    cursor = 0
    state = @initial_state
    @steps.times do
      value, direction, state = @states[state][tape[cursor]]
      tape[cursor] = value
      cursor += direction
    end
    tape.values.sum
  end

  def part_2
  end
end

Day25.run if __FILE__ == $0

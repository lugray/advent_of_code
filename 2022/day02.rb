#!/usr/bin/env ruby

require_relative 'day'

class Day02 < Day
  CHOICE_POINTS = { rock: 1, paper: 2, scissors: 3 }
  RESULT_POINTS = { win: 6, draw: 3, loss: 0 }
  BEATS = { rock: :paper, paper: :scissors, scissors: :rock }
  LOOSES_TO = BEATS.invert
  CHOICE = { 'A' => :rock, 'B' => :paper, 'C' => :scissors, 'X' => :rock, 'Y' => :paper, 'Z' => :scissors }
  INSTRUCTION = { 'X' => :loss, 'Y' => :draw, 'Z' => :win }
  TO_GET = {
    win: ->(opp_choice) { BEATS[opp_choice] },
    draw: ->(opp_choice) { opp_choice },
    loss: ->(opp_choice) { LOOSES_TO[opp_choice] },
  }

  def initialize
    @rounds = input_lines
  end

  def score(choice, result)
    CHOICE_POINTS[choice] + RESULT_POINTS[result]
  end

  def result(opp_choice, my_choice)
    TO_GET.transform_values { |f| f.call(opp_choice) }.invert[my_choice]
  end

  def pick(opp_choice, instruction)
    TO_GET[instruction].call(opp_choice)
  end

  def part_1
    @rounds.sum do |line|
      opp_choice, my_choice = line.split(' ').map { |c| CHOICE[c] }
      score(my_choice, result(opp_choice, my_choice))
    end
  end

  def part_2
    @rounds.sum do |line|
      opp_choice, instruction = line.split(' ').then { |c, i| [CHOICE[c], INSTRUCTION[i]] }
      my_choice = pick(opp_choice, instruction)
      score(my_choice, instruction)
    end
  end
end

Day02.run if __FILE__ == $0

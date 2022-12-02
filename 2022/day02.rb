#!/usr/bin/env ruby

require_relative 'day'

class Day02 < Day
  def initialize
    @rounds = input_lines
  end

  def choice_points(choice)
    case choice
      when 'R'; 1
      when 'P'; 2
      when 'S'; 3
    end
  end

  def result_points(result)
    case result
      when 'W'; 6
      when 'D'; 3
      when 'L'; 0
    end
  end

  def score(choice, result)
    choice_points(choice) + result_points(result)
  end

  def result(opp_choice, my_choice)
    case [opp_choice, my_choice].join.tr('RPS', '123').chars.map(&:to_i).reduce(:-).modulo(3)
      when 0; 'D'
      when 1; 'L'
      when 2; 'W'
    end
  end

  def pick(opp_choice, instruction)
    options = %w(R P S)
    opp_index = options.index(opp_choice)
    case instruction
      when 'L'; options[(opp_index - 1) % 3]
      when 'D'; opp_choice
      when 'W'; options[(opp_index + 1) % 3]
    end
  end

  def part_1
    @rounds.sum do |line|
      opp_choice, my_choice = line.tr('ABCXYZ', 'RPSRPS').split(' ')
      score(my_choice, result(opp_choice, my_choice))
    end
  end

  def part_2
    @rounds.sum do |line|
      opp_choice, instruction = line.split(' ')
      instruction.tr!('XYZ', 'LDW')
      opp_choice = opp_choice.tr('ABC', 'RPS')
      my_choice = pick(opp_choice, instruction)
      score(my_choice, instruction)
    end
  end
end

Day02.run if __FILE__ == $0

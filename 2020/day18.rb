#!/usr/bin/env ruby

require_relative 'day'

class Calculation
  INNER_PARENS = /\([^()]+\)/
  ADDITION = /\d+ \+ \d+/

  def initialize(str)
    @str = str
  end

  def value(addition_first: false)
    if (matches = @str.scan(INNER_PARENS)).any?
      subs = matches.map { |p| [p, Calculation.new(p[1...-1]).value(addition_first: addition_first).to_s] }.to_h
      Calculation.new(@str.gsub(INNER_PARENS, subs)).value(addition_first: addition_first)
    elsif addition_first && (matches = @str.scan(ADDITION)).any? && matches.first != @str
      subs = matches.map { |p| [p, Calculation.new(p).value(addition_first: addition_first).to_s] }.to_h
      Calculation.new(@str.gsub(ADDITION, subs)).value(addition_first: addition_first)
    else
      val = nil
      op = nil
      @str.split(' ').map { |t| t.to_i.to_s == t ? t.to_i : t }.each do |token|
        case token
        when Integer
          if val.nil?
            val = token
          else
            case op
            when '+'
              val += token
            when '*'
              val *= token
            else
              raise 'wut'
            end
          end
        when '+', '*'
          op = token
        else
          raise 'wut'
        end
      end
      val
    end
  end
end

class Day18 < Day
  def initialize
    @calculations = input.each_line(chomp: true).map { |l| Calculation.new(l) }
  end

  def part_1
    @calculations.sum(&:value)
  end

  def part_2
    @calculations.sum { |c| c.value(addition_first: true) }
  end
end

Day18.run if __FILE__ == $0

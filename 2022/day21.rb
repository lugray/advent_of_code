#!/usr/bin/env ruby

require_relative 'day'

class Day21 < Day
  def initialize
    @instructions = input_lines do |line|
      name, val = line.split(': ')
    end.to_h
  end

  class Solver
    def initialize(instructions)
      @instructions = instructions
    end

    def value_of(name)
      if val = @instructions[name]
        if val =~ /\A-?\d+\z/
          val.to_i
        else
          a, op, b = val.split(' ')
          a = value_of(a)
          b = value_of(b)
          case op
          when '+' then a + b
          when '*' then a * b
          when '/' then a / b
          when '-' then a - b
          else raise "Unknown op #{op}"
          end
        end
      else
        reverse_value_of(name)
      end
    end

    def reverse_value_of(name)
      key, val = @instructions.find do |k, v|
        v.include?(name)
      end
      if key.nil?
        raise "No key found for #{name}"
      end
      a, op, b = val.split(' ')
      r = reverse_value_of(key) unless op == '='
      case op
      when '+'
        v = [a, b].reject { |x| x == name }.first
        r - value_of(v)
      when '*'
        v = [a, b].reject { |x| x == name }.first
        r / value_of(v)
      when '/'
        if a == name
          r * value_of(b)
        else
          value_of(a) / r
        end
      when '-'
        if a == name
          r + value_of(b)
        else
          value_of(a) - r
        end
      when '='
        v = [a, b].reject { |x| x == name }.first
        value_of(v)
      else raise "Unknown op #{op}"
      end
    end
  end

  def part_1
    Solver.new(@instructions).value_of('root')
  end

  def part_2
    instructions = @instructions.dup
    instructions['root'].sub!(/ . /, ' = ')
    instructions.delete('humn')
    Solver.new(instructions).value_of('humn')
  end
end

Day21.run if __FILE__ == $0

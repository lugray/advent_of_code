#!/usr/bin/env ruby

require_relative 'day'

class Operation
  class << self
    def identity(modulo)
      new(1, 0, modulo)
    end
  end

  attr_reader :factor, :offset, :modulo

  def initialize(factor, offset, modulo)
    @factor = factor.modulo(modulo)
    @offset = offset.modulo(modulo)
    @modulo = modulo
  end

  def *(other)
    case other
    when Integer
      apply_to(other)
    when Operation
      convolve(other)
    else
      raise "Cannot multiply with type #{other.class} (#{other})"
    end
  end

  def **(n)
    return invert ** -n if n < 0

    curr = self
    final = Operation.identity(modulo)
    n.digits(2).each do |d|
      final = final * curr if d == 1
      curr = curr * curr
    end
    final
  end

  private

  def apply_to(other)
    (other * factor + offset).modulo(modulo)
  end

  def convolve(other)
    raise "Modulo mismatch (#{modulo} != #{other.modulo})" unless modulo == other.modulo
    Operation.new(factor * other.factor, factor * other.offset + offset, modulo)
  end

  def invert
    inverse_factor = inverse(factor)
    Operation.new(inverse_factor, -inverse_factor * offset, modulo)
  end

  def inverse(n)
    # perform (factor ** (modulo - 2)).modulo(modulo) without overflow by taking intermediate modulos
    curr = n
    final = 1
    (modulo - 2).digits(2).each do |d|
      final = (final * curr).modulo(modulo) if d == 1
      curr = (curr * curr).modulo(modulo)
    end
    final
  end
end

class Day22 < Day
  def full_shuffle(prime)
    input.each_line.inject(Operation.identity(prime)) do |op, line|
      parts = line.chomp.split(' ')
      case parts[0..-2]
      when ['deal', 'into', 'new']
        Operation.new(-1, -1, prime) * op
      when ['cut']
        Operation.new(1, -parts.last.to_i, prime) * op
      when ['deal', 'with', 'increment']
        Operation.new(parts.last.to_i, 0, prime) * op
      end
    end
  end

  def part_1
    full_shuffle(10007) * 2019
  end

  def part_2
    full_shuffle(119315717514047) ** -101741582076661 * 2020
  end
end

Day22.run if __FILE__ == $0

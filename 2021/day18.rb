#!/usr/bin/env ruby

require_relative 'day'

class Array
  def dig_set(address, val)
    if address.length > 1
      dig(*address[...-1])[address[-1]] = val
    else
      self[address[-1]] = val
    end
  end

  def dig_add(address, val)
    if address.length > 1
      dig(*address[...-1])[address[-1]] += val
    else
      self[address[-1]] += val
    end
  end

  def deep_dup
    map { |it| it.deep_dup }
  end
end

class Integer
  def deep_dup
    self
  end
end

class Day18 < Day
  class SnailFish
    def initialize(arr)
      @arr = arr
    end

    def to_a
      @arr.deep_dup
    end

    def magnitude
      return @arr if @arr.is_a?(Integer)
      SnailFish.new(@arr.first).magnitude * 3 + SnailFish.new(@arr.last).magnitude * 2
    end

    def reduce
      while explode || split do
      end
      self
    end

    def addresses(arr = @arr)
      return enum_for(:addresses, arr) unless block_given?
      return yield [] if arr.is_a?(Integer)
      addresses(arr.first).each do |a|
        yield [0] + a
      end
      addresses(arr.last).each do |a|
        yield [1] + a
      end
    end

    def explode
      [nil].chain(addresses).chain([nil, nil]).each_cons(4) do |last_address, address_left, address_right, next_address|
        if address_left.length > 4
          if last_address
            @arr.dig_add(last_address, @arr.dig(*address_left))
          end
          if next_address
            @arr.dig_add(next_address, @arr.dig(*address_right))
          end
          @arr.dig_set(address_left[...-1], 0)
          return true
        end
      end
      false
    end

    def split
      addresses.each do |address|
        if (val = @arr.dig(*address)) >= 10
          a = val/2
          b = val - a
          @arr.dig_set(address, [a, b])
          return true
        end
      end
      false
    end

    def +(other)
      SnailFish.new([to_a, other.to_a]).reduce
    end
  end

  def initialize
    @numbers = input_lines.map do |line|
      SnailFish.new(eval(line))
    end
  end

  def part_1
    @numbers.inject(&:+).magnitude
  end

  def part_2
    @numbers.permutation(2).map { |a, b| (a+b).magnitude }.max
  end
end

Day18.run if __FILE__ == $0

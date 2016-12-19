class String
  def to_i_if_reasonable
    if /^\d+$/ =~ self
      self.to_i
    else
      self
    end
  end
end

class LogicGates
  def initialize(input)
    @input = input.each_line.map(&:strip).reject{ |line| line == "" }.map do |connection|
      if matches = connection.scan(/^([a-z\d]+) -> ([a-z]+)/).first
        matches.map!(&:to_i_if_reasonable).unshift(:connect_direct)
      elsif matches = connection.scan(/^([A-Z]+) ([a-z\d]+) -> ([a-z]+)/).first
        matches.map!(&:downcase).map!(&:to_i_if_reasonable)
        matches[0] = :"connect_#{matches[0]}"
        matches
      elsif matches = connection.scan(/^([a-z\d]+) ([A-Z]+) ([a-z\d]+) -> ([a-z]+)/).first
        matches.map!(&:downcase).map!(&:to_i_if_reasonable)
        matches[1] = :"connect_#{matches[1]}"
        [matches[1], matches[0], matches[2], matches[3]]
      else
        raise
      end
    end
    @value = {}
  end

  def over_ride(wire, value)
    @value[wire] = value
    self
  end

  def value(wire)
    return wire if wire.is_a?(Fixnum)
    return @value[wire] if @value[wire]
    instructions = @input.find { |instructions| instructions.last == wire }
    send(*instructions)
  end

  def connect_direct(from, to)
    @value[to] = value(from)
  end

  def connect_or(a, b, to)
    @value[to] = value(a) | value(b)
  end

  def connect_and(a, b, to)
    @value[to] = value(a) & value(b)
  end

  def connect_lshift(a, b, to)
    @value[to] = value(a) << value(b)
  end

  def connect_rshift(a, b, to)
    @value[to] = value(a) >> value(b)
  end

  def connect_not(from, to)
    @value[to] = 65535 ^ value(from)
  end

  def connect_xor(a, b, to)
    @value[to] = value(a) ^ value(b)
  end
end

puts part1 = LogicGates.new(File.open(File.dirname(__FILE__) + '/input.txt').read).value('a')
puts LogicGates.new(File.open(File.dirname(__FILE__) + '/input.txt').read).over_ride('b', part1).value('a')


#!/usr/bin/env ruby

class PlantLife
  def initialize(input)
    lines = input.each_line.map(&:chomp).reject(&:empty?)
    state_string = lines.shift["initial state: ".length..-1]
    @state = state_string.each_char.each_with_index.map {|v, i| [i, true] if v == "#"}.compact.to_h
    @rules = lines.map do |line|
      [line[0..4].each_char.map { |v| true if v == "#" }, line[-1] == "#"]
    end.to_h
  end

  def to_s
    l, h = @state.keys.minmax
    "(#{l},#{h}): " + (l..h).map { |i| @state[i] ? '#' : '.' }.join
  end

  def sum
    @state.keys.sum
  end

  def step(n=1, verbose: false, optimize: true)
    n.times do |i|
      consider = @state.keys.flat_map { |i| [i - 2, i - 1, i, i + 1, i + 2] }.uniq
      new_state = consider.map do |i|
        if @rules[@state.values_at(i - 2, i - 1, i, i + 1, i + 2)]
          [i, true]
        end
      end.compact.to_h
      if optimize
        shift = (-2..2).find do |delta|
          @state.keys.zip([delta].cycle).map(&:sum) == new_state.keys
        end
        if shift
          @state = @state.keys.zip([shift * (n - i)].cycle).map(&:sum).map { |v| [v, true] }.to_h
          break
        end
      end
      @state = new_state
      puts self if verbose
    end
    self
  end
end

input = 'initial state: #..#.#..##......###...###

...## => #
..#.. => #
.#... => #
.#.#. => #
.#.## => #
.##.. => #
.#### => #
#.#.# => #
#.### => #
##.#. => #
##.## => #
###.. => #
###.# => #
####. => #
'
input = File.read('input')
puts PlantLife.new(input).step(20).sum
puts PlantLife.new(input).step(50000000000).sum

require 'matrix'

class Delivery
  MOVES = {
    '^' => Vector[0, 1],
    'v' => Vector[0, -1],
    '>' => Vector[1, 0],
    '<' => Vector[-1, 0],
  }

  def initialize(input)
    @input = input.each_char.reject { |char| !MOVES.keys.include?(char) }
  end

  def number_visited
    pos = Vector[0, 0]
    visited = [pos]
    @input.each do |char|
      pos += MOVES[char]
      visited.push(pos)
    end
    visited.uniq!.size
  end

  def robo_visited
    pos1 = Vector[0, 0]
    pos2 = Vector[0, 0]
    visited = [pos1]
    @input.each_slice(2) do |chars|
      pos1 += MOVES[chars.first]
      pos2 += MOVES[chars.last] if chars.last
      visited.push(pos1)
      visited.push(pos2)
    end
    visited.uniq!.size
  end
end

delivery = Delivery.new(File.open(File.dirname(__FILE__) + '/input.txt').read)
puts delivery.number_visited
puts delivery.robo_visited
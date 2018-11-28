class Packet
  def initialize(input)
    @maze = input.split("\n").map do |line|
      line.each_char.to_a
    end
  end

  def solve
    @pos = [0, @maze[0].index('|')]
    @dir = :down
    @out = String.new
    @steps = 0
    catch(:done) do
      loop do
        @steps += 1
        @pos = advance
        process
      end
    end
    [@out, @steps]
  end

  private

  def advance(pos: @pos, dir: @dir)
    pos = pos.dup
    case dir
    when :down
      pos[0] += 1
    when :up
      pos[0] -= 1
    when :left
      pos[1] -= 1
    when :right
      pos[1] += 1
    end
    pos
  end

  def process
    case @maze.dig(*@pos)
    when '|'
    when '-'
    when '+'
      dirs = if [:left, :right].include?(@dir)
        [:up, :down]
      else
        [:left, :right]
      end
      @dir = dirs.find{ |dir| @maze.dig(*advance(dir: dir)) != ' ' }
    when /[A-Za-z]/
      @out << @maze.dig(*@pos)
    else
      throw :done
    end
  end
end

input = File.open(File.dirname(__FILE__) + '/input').read.chomp

# input = [
#   '     |          ',
#   '     |  +--+    ',
#   '     A  |  C    ',
#   ' F---|----E|--+ ',
#   '     |  |  |  D ',
#   '     +B-+  +--+ ',
# ].join("\n")

puts Packet.new(input).solve


require 'byebug'

class Carrier
  attr_reader :infections

  CHARMAP = ['.', 'W', '#', 'F']

  def initialize(input)
    @grid = Hash.new { |hash, key| hash[key] = Hash.new { |hash2, key2| hash2[key2] = 0 } }
    input.split("\n").each_with_index do |line, i|
      line.each_char.each_with_index do |char, j|
        @grid[i][j] = (char == '#') ? 2 : 0
      end
    end
    @row = input.split("\n").count / 2
    @col = input.split("\n").first.size / 2
    @dirs = [:up, :left, :down, :right]
    @infections = 0
  end

  def move(n = 1)
    n.times do
      turn
      toggle
      advance
    end
  end

  def print
    row_indices = @grid.keys
    min_row = row_indices.min
    max_row = row_indices.max
    col_indices = @grid.values.map(&:keys).flatten
    min_col = col_indices.min
    max_col = col_indices.max
    out = (min_row..max_row).map do |i|
      (min_col..max_col).map do |j|
        ((@row == i && @col == j) ? '[' : ' ') +
        CHARMAP[@grid[i][j]] +
        ((@row == i && @col == j) ? ']' : ' ')
      end.join
    end
    puts out
  end

  private

  def turn
    @dirs.rotate!(infected? ? -1 : 1)
  end

  def toggle
    @grid[@row][@col] = infected? ? 0 : 2
    @infections += 1 if infected?
  end

  def advance
    case @dirs.first
    when :up
      @row -= 1
    when :left
      @col -= 1
    when :down
      @row += 1
    when :right
      @col += 1
    end
  end

  def clean?
    node == 0
  end

  def infected?
    node == 2
  end

  def node
    @grid[@row][@col]
  end
end

class FancyCarrier < Carrier

  private

  def turn
    if clean?
      @dirs.rotate!(1)
    elsif infected?
      @dirs.rotate!(-1)
    elsif flagged?
      @dirs.rotate!(2)
    end
  end

  def toggle
    @grid[@row][@col] = (@grid[@row][@col] + 1) % 4
    @infections += 1 if infected?
  end

  def weakened?
    @grid[@row][@col] == 1
  end

  def flagged?
    @grid[@row][@col] == 3
  end
end

input = File.open(File.dirname(__FILE__) + '/input').read.chomp

# input = '..#
# #..
# ...'

c = Carrier.new(input)
c.move(10000)
puts c.infections

c = FancyCarrier.new(input)
c.move(10000000)
puts c.infections


require 'byebug'

class Traps
  def initialize(input, rows)
    @rows = rows
    @cols = input.length
    @tiles = Array.new(@rows) { Array.new(@cols) }
    @tiles[0] = input.each_char.map{ |char| char == '^' }
  end

  def trap?(row, col)
    return false if col < 0 || col >= @cols
    return @tiles[row][col] unless @tiles[row][col].nil?
    @tiles[row][col] = compute_trap?(row, col)
  end

  def compute_trap?(row, col)
    trap?(row-1, col-1) ^ trap?(row-1, col+1)
  end

  def fill_map
    (1..@rows-1).each { |row| (0..@cols-1).each { |col| trap?(row, col) } }
    self
  end

  def count_safe
    @tiles.flatten.count(false)
  end

  def print_map
    puts @tiles.map { |row| row.map { |tile| tile ? '^' : '.' }.join }
    self
  end
end

class TrapCount
  def initialize(input, rows)
    @input = input.each_char.map{ |char| char == '^' }
    @rows = rows
  end

  def count_safe
    prev_row = @input
    safe = prev_row.count(false)
    (@rows-1).times do
      prev_row = (0..prev_row.length-1).map do |col|
        if col == 0
          prev_row[1]
        elsif col == @cols
          prev_row[col-1]
        else
          prev_row[col-1] ^ prev_row[col+1]
        end
      end
      safe += prev_row.count(false)
    end
    safe
  end
end

traps = Traps.new('^.....^.^^^^^.^..^^.^.......^^..^^^..^^^^..^.^^.^.^....^^...^^.^^.^...^^.^^^^..^^.....^.^...^.^.^^.^', 40)
puts traps.fill_map.print_map.count_safe
traps = TrapCount.new('^.....^.^^^^^.^..^^.^.......^^..^^^..^^^^..^.^^.^.^....^^...^^.^^.^...^^.^^^^..^^.....^.^...^.^.^^.^', 400000)
puts traps.count_safe

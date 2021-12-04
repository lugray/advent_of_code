#!/usr/bin/env ruby

require_relative 'day'

class Day04 < Day
  class Board
    def initialize(input)
      @board = input.split("\n").map { |r| r.split(' ').map(&:to_i) }
      @marks = Array.new(5) { Array.new(5) { false } }
    end

    def call(number)
      return if won?
      @board.each_with_index do |row, i|
        row.each_with_index do |num, j|
          if num == number
            @marks[i][j] = true
            break
          end
        end
      end
    end

    def row_win?
      @marks.any? { |row| row.all? }
    end

    def col_win?
      @marks.transpose.any? { |col| col.all? }
    end

    def won?
      # Intentionally only memoizes true
      @won ||= row_win? || col_win?
    end

    def playing?
      !won?
    end

    def unmarked_sum
      @board.flatten.zip(@marks.flatten).sum do |num, mark|
        mark ? 0 : num
      end
    end
  end

  def initialize
    parts = input.split("\n\n")
    @numbers = parts.shift.split(',').map(&:to_i).to_enum
    @boards = parts.map { |p| Board.new(p) }
  end

  def call
    @last_called = @numbers.next.tap { |num| @boards.each { |b| b.call(num) } }
  end

  def play_until
    until yield
      call
    end
  end

  def part_1
    play_until { @boards.count(&:won?) == 1 }
    @boards.find(&:won?).unmarked_sum * @last_called
  end

  def part_2
    play_until { @boards.count(&:playing?) == 1 }
    big_looser = @boards.find(&:playing?)
    play_until { @boards.count(&:playing?) == 0 }
    big_looser.unmarked_sum * @last_called
  end
end

Day04.run if __FILE__ == $0

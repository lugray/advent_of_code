#!/usr/bin/env ruby

require_relative 'day'

class Day10 < Day
  class Line
    class ChunkError < StandardError
      attr_reader :bad_char
      def initialize(bad_char)
        @bad_char = bad_char
      end
    end

    PAIRS = {
      '(' => ')',
      '[' => ']',
      '{' => '}',
      '<' => '>',
    }

    ERROR_POINTS = {
      ')' => 3,
      ']' => 57,
      '}' => 1197,
      '>' => 25137,
    }.tap { |h| h.default = 0 }

    COMPLETION_POINTS = {
      ')' => 1,
      ']' => 2,
      '}' => 3,
      '>' => 4,
    }

    def initialize(code)
      @code = code
    end

    def illegal_char
      parse
      nil
    rescue ChunkError => e
      e.bad_char
    end

    def parse
      @code.each_char.each_with_object([]) do |c, stack|
        if PAIRS.keys.include?(c)
          stack.push(c)
        elsif c == PAIRS[stack.last]
          stack.pop
        else
          raise(ChunkError, c)
        end
      end
    end

    def completion_score
      parse.reverse.inject(0) do |score, c|
        score * 5 + COMPLETION_POINTS[PAIRS[c]]
      end
    end
  end

  def initialize
    @lines = input_lines.map { |l| Line.new(l.chomp) }
  end

  def part_1
    @lines.sum{ |l| Line::ERROR_POINTS[l.illegal_char] }
  end

  def part_2
    scores = @lines.reject(&:illegal_char).map(&:completion_score).sort
    scores[scores.size / 2]
  end
end

Day10.run if __FILE__ == $0

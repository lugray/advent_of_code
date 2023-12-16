module Enumerable
  def cyclic_at(i)
    seen = {}
    each_with_index do |e, j|
      return e if j == i
      return seen.key(seen[e]+(i-j) % (j-seen[e])) if seen.key?(e)
      seen[e] = j
    end
  end
end

class String
  def to_i_if_i
    i = to_i
    i.to_s == self ? i : self
  end

  def ints
    scan(/-?\d+/).map(&:to_i)
  end
end

class TrackMax
  attr_reader :max

  def <<(x)
    @max = x if @max.nil? || x > @max
  end
end

class Day
  def input
    if ARGV.include?('--example')
      maybe_n = ARGV[ARGV.index('--example') + 1]
      if maybe_n =~ /\d+/
        File.read("#{self.class.to_s.downcase}.example.#{maybe_n}")
      else
        File.read("#{self.class.to_s.downcase}.example")
      end
    else
      File.read("#{self.class.to_s.downcase}.input")
    end
  end

  def input_paragraphs
    input.split("\n\n")
  end

  def input_lines(&block)
    block ||= proc(&:itself)
    input.each_line(chomp: true).map(&block)
  end

  def input_grid(sep: ' ', &block)
    if block
      input_lines { |line| line.split(sep).map(&block) }
    else
      input_lines { |line| line.split(sep) }
    end
  end

  def quadratic(a, b, c)
    [
      (-b - Math.sqrt(b**2 - 4 * a * c)) / (2 * a),
      (-b + Math.sqrt(b**2 - 4 * a * c)) / (2 * a),
    ]
  end

  class << self
    def run
      day = new
      puts day.part_1 unless ARGV.include?('--part2') && !ARGV.include?('--part1')
      puts day.part_2 unless ARGV.include?('--part1') && !ARGV.include?('--part2')
    end

    def output
      day = new
      [day.part_1, day.part_2].join("\n")
    end
  end
end

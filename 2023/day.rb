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

  def input_lines(&block)
    block ||= method(:to_i_if_i)
    input.each_line(chomp: true).map(&block)
  end

  def input_grid(sep = ' ', &block)
    block ||= method(:to_i_if_i)
    input_lines { |line| line.split(sep).map(&block) }
  end

  def to_i_if_i(s)
    s =~ /-?\d+/ ? s.to_i : s
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

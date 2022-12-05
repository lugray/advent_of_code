class Day
  def input
    if ARGV.include?('--example')
      File.read("#{self.class.to_s.downcase}.example")
    else
      File.read("#{self.class.to_s.downcase}.input")
    end
  end

  def input_lines
    input.each_line.map(&:chomp)
  end

  def input_numbers
    if input.include?(',')
      input.split(',').map(&:to_i)
    else
      input_lines.map(&:to_i)
    end
  end

  class << self
    def run
      day = new
      puts day.part_1
      puts day.part_2
    end

    def output
      day = new
      [day.part_1, day.part_2].join("\n")
    end
  end
end

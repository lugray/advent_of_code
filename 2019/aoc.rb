module AOC
  class << self
    def input
      File.read("#{File.basename($0, '.rb')}.input")
    end
  end
end

class Day
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

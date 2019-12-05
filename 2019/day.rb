class Day
  def input
    File.read("#{self.class.to_s.downcase}.input")
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

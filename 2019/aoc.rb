module AOC
  class << self
    def input
      File.read("#{File.basename($0, '.rb')}.input")
    end
  end
end

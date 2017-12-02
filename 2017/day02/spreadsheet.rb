class Spreadsheet
  def initialize(data)
    @data = data.split("\n").map do |line|
      line.split(' ').map(&:to_i)
    end
  end

  def checksum
    differences = @data.map do |row|
      row.max - row.min
    end
    differences.inject(&:+)
  end

  def divsum
    divisions = @data.map do |row|
      denominator, numerator = row.sort.combination(2).find do |a, b|
        b % a == 0
      end
      numerator / denominator
    end
    divisions.inject(&:+)
  end
end

input = File.read(File.dirname(__FILE__) + '/input').chomp
spreadsheet = Spreadsheet.new(input)
puts spreadsheet.checksum
puts spreadsheet.divsum

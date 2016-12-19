class ErrorCorrect
  def initialize(input)
    @input = input.each_line.map(&:strip).reject{ |line| line == "" }
    @counts = Array.new(@input.map(&:size).max) { Hash.new { 0 } }
    @counted = false
  end

  def count
    unless @counted
      @input.each do |line|
        line.chars.each_index{ |i| @counts[i][line[i]] += 1 }
      end
      @counted = true
    end
  end

  def ordered
    count
    @ordered ||= @counts.map do |count|
      count.to_a.map(&:reverse).sort.map(&:last)
    end
  end

  def get_message
    ordered.map(&:last).join
  end

  def get_alt_message
    ordered.map(&:first).join
  end
end

puts ErrorCorrect.new(File.open(File.dirname(__FILE__) + '/input.txt').read).get_message
puts ErrorCorrect.new(File.open(File.dirname(__FILE__) + '/input.txt').read).get_alt_message

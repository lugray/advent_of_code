class StringParse
  def initialize(input)
    @input = input.each_line.map(&:strip).reject{ |line| line == "" }
  end

  def savings
    @input.join.length -
    eval('['+@input.join(',')+']').map(&:length).inject(:+)
  end

  def worse_count
    @input.map(&:inspect).join.length -
    @input.join.length
  end
end

parser = StringParse.new(File.open(File.dirname(__FILE__) + '/input.txt').read)
puts parser.savings
puts parser.worse_count

class WrappingPaper
  def initialize(input)
    @input = input.each_line.map(&:strip).reject{ |line| line == "" }.map do |line|
      line.scan(/(\d+)x(\d+)x(\d+)/).first.map(&:to_i)
    end
  end

  def get_square_feet
    @input.map do |dim|
      x,y,z = *dim
      sides=[x*y, x*z, y*z]
      sides.min + 2 * sides.inject(:+)
    end.inject(:+)
  end

  def get_ribbon
    @input.map do |dim|
      (dim.inject(:+) - dim.max) * 2 + dim.inject(:*)
    end.inject(:+)
  end
end

wrapping_paper = WrappingPaper.new(File.open(File.dirname(__FILE__) + '/input.txt').read)
puts wrapping_paper.get_square_feet
puts wrapping_paper.get_ribbon
class Brackets
  def initialize(input)
    @input = input
  end

  def final_floor(input = @input)
    input.count('(') - input.count(')')
  end

  def first_baseent_visit
    (1..@input.length).each do |i|
      return i if final_floor(@input[0, i]) == -1
    end
  end
end

brackets = Brackets.new(File.open(File.dirname(__FILE__) + '/input.txt').read)
puts brackets.final_floor
puts brackets.first_baseent_visit
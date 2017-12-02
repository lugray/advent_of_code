class Captcha
  def initialize(input)
    @input = input.each_char.map(&:to_i)
    @mod = @input.length
  end

  def matching(offset)
    @input.each_with_index.select do |num, index|
      num == @input[(index+offset) % @mod]
    end.map(&:first)
  end

  def matching_sum(offset)
    matching(offset).inject(&:+)
  end
end

input = File.read(File.dirname(__FILE__) + '/input').chomp
captcha = Captcha.new(input)

puts captcha.matching_sum(1)
puts captcha.matching_sum(input.length/2)

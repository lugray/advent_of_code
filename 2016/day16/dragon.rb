require 'prime'

class Dragon
  def initialize(input, target_length=272)
    @input = input
    @target_length=target_length
  end

  def dragon_step(str)
    str + "0" + str.reverse.each_char.map { |char| char == "1" ? "0" : "1" }.join
  end

  def extend_to_target(str)
    final = str
    while final.length < @target_length
      final = dragon_step(final)
    end
    final[0, @target_length]
  end

  def check_step(str)
    str.scan(/../).map{ |pair| /(.)\1/ =~ pair ? "1" : "0" }.join
  end

  def check_sum(str)
    final = str
    while final.length.even?
      final = check_step(final)
    end
    final
  end

  def ans
    check_sum(extend_to_target(@input))
  end
end

class EnumeratedDragon
  def initialize(input, length)
    @dragon = (1..Float::INFINITY).each.lazy.map{ |n| (((n & -n) << 1) & n) != 0 ? '1' : '0' }
    @input = input
    @flop_input = input.reverse.each_char.map { |char| char == "1" ? "0" : "1" }.join
    @extended = Enumerator.new do |y|
      loop do
        @input.each_char { |char| y << char }
        y << @dragon.next
        @flop_input.each_char { |char| y << char }
        y << @dragon.next
      end
    end
    prime_division = Prime.prime_division(length)
    @steps = prime_division.find{ |factor| factor.first==2 }.last
    @code_length = Prime.int_from_prime_division(prime_division.reject{ |factor| factor.first==2 })
  end

  def ans(steps = @steps, code_length = @code_length)
    current = @extended
    steps.times do
      current = current.each_slice(2).lazy.map{ |pair| pair.first == pair.last ? "1" : "0" }
    end
    current.first(code_length).join
  end

  def extended
    @extended
  end

  def dragon
    @dragon
  end
end

# puts Dragon.new('00111101111101000').ans
# puts Dragon.new('00111101111101000', 35651584).ans
puts EnumeratedDragon.new('00111101111101000', 272).ans
puts EnumeratedDragon.new('00111101111101000', 35651584).ans

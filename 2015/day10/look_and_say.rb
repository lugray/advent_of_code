class LookAndSay
  def initialize(input)
    @input = input
  end

  def step(prev)
    prev.scan(/((.)\2*)/).map(&:first).map{ |part| part.length.to_s + part[0] }.join
  end

  def nth(n)
    prev = @input
    n.times { prev = step(prev) }
    prev
  end
end

look_and_say = LookAndSay.new('1321131112')
puts look_and_say.nth(40).length
puts look_and_say.nth(50).length
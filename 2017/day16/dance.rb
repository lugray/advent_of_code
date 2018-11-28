class String
  def spin!(n)
    temp = self[-n..-1]
    self[n-length..-1] = self[0...-n]
    self[0...n] = temp
    self
  end

  def exchange!(a, b)
    self[a], self[b] = self[b], self[a]
    self
  end

  def partner!(a, b)
    exchange!(index(a), index(b))
  end
end

dancers =

input = File.read(File.dirname(__FILE__) + '/input').chomp

moves = input.split(',').map do |m|
  if parts = m.match(/s(\d+)/)&.captures&.map(&:to_i)
    [:spin!, *parts]
  elsif parts = m.match(/x(\d+)\/(\d+)/)&.captures&.map(&:to_i)
    [:exchange!, *parts]
  elsif parts = m.match(/p(\w)\/(\w)/)&.captures
    [:partner!, *parts]
  else
    raise ArgumentError m
  end
end

def dance(dancers, moves)
  dance!(dancers.dup, moves)
end

def dance!(dancers, moves)
  moves.each do |m|
    dancers.send(*m)
  end
  dancers
end

start = ("a".."p").to_a.join
finish =  dance(start, moves)

puts finish

dancers = finish.dup

n = 1

while dancers != start
  n += 1
  dance!(dancers, moves)
end

dancers = start.dup

(1_000_000_000 % n).times do
  dance!(dancers, moves)
end
puts dancers
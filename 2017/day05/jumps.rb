input = File.read(File.dirname(__FILE__) + '/input').chomp

jumps = input.split("\n").map(&:to_i)

def steps_out(jumps, decrease_for_large: false)
  jumps = jumps.dup
  pos = 0
  steps = 0
  while pos >=0 && pos < jumps.length do
    steps += 1
    jump = jumps[pos]
    if jump >= 3 && decrease_for_large
      jumps[pos] -= 1
    else
      jumps[pos] += 1
    end
    pos += jump
  end
  steps
end

puts steps_out(jumps)
puts steps_out(jumps, decrease_for_large: true)
input = File.read(File.dirname(__FILE__) + '/input').chomp
memory = input.split("\t").map(&:to_i)

seen = [memory.to_s.hash]

def redistribute(arr)
  max_val = arr.max
  loc = arr.index(max_val)
  arr[loc] = 0
  max_val.times do |i|
    arr[(loc + i + 1) % arr.size] += 1
  end
end

hashed_memory = ""
loop do
  redistribute(memory)
  hashed_memory = memory.to_s.hash
  break if seen.include?(hashed_memory)
  seen << hashed_memory
end

puts seen.size
puts seen.size - seen.index(hashed_memory)
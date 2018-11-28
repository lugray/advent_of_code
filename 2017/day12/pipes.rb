input = File.read(File.dirname(__FILE__) + '/input').chomp

pipes = input.split("\n").map do |line|
  a, bs = line.split(" <-> ")
  [a.to_i, bs.split(", ").map(&:to_i)]
end.to_h

sets = []
ungrouped = pipes.keys

def add(id, connected, pipes)
  return if connected.include?(id)
  connected << id
  pipes[id].each do |b|
    add(b, connected, pipes)
  end
end

loop do
  break if ungrouped.empty?
  connected = []
  sets << connected
  add(ungrouped.first, connected, pipes)
  ungrouped -= connected
end

puts sets[0].length
puts sets.length
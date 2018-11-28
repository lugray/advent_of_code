memory = [0]
pos = 0
step = 349

(1..2017).each do |i|
  pos = (pos+step) % memory.length + 1
  memory.insert(pos, i)
end

puts memory[memory.index(2017)+1]

ml = memory.length
v1 = memory[1]
(2018..50_000_000).each do |i|
  pos = (pos+step) % ml + 1
  if pos == 1
    v1 = i
  end
  ml += 1
end

puts v1

input = File.read(File.dirname(__FILE__) + '/input').chomp

passphrases = input.split("\n").map do |line|
  line.split(' ')
end

no_repeat_count = passphrases.count do |passphrase|
  passphrase.length == passphrase.uniq.length
end

no_anagram_count = passphrases.count do |passphrase|
  sorted = passphrase.map do |word|
    word.each_char.sort.join
  end
  sorted.length == sorted.uniq.length
end

puts no_repeat_count
puts no_anagram_count
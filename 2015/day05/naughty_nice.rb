class NaughtyNice
  def initialize(input)
    @input = input.each_line.map(&:strip).reject{ |line| line == "" }
  end

  def count_nice
    @input.count do |word|
      word.count('aeiou') >= 3 &&
      /(.)\1/ =~ word &&
      !(/ab|cd|pq|xy/ =~ word)
    end
  end

  def count_new_nice
    @input.count do |word|
      /(..).*\1/ =~ word &&
      /(.).\1/ =~ word
    end
  end
end

naughty_nice = NaughtyNice.new(File.open(File.dirname(__FILE__) + '/input.txt').read)
puts naughty_nice.count_nice
puts naughty_nice.count_new_nice
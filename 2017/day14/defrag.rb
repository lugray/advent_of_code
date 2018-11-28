class Knot
  def self.from_string(str)
    new(str.each_char.map(&:ord) + [17, 31, 73, 47, 23])
  end

  def initialize(twists)
    @twists = twists
    @string = (0..255).to_a
    @total_rotation = 0
    @skip = 0
  end

  def run(n = 1)
    if n > 1
      n.times do
        run
      end
      return
    end
    @twists.each do |twist|
      @string[0...twist] = @string[0...twist].reverse
      @string.rotate!(twist+@skip)
      @total_rotation += twist+@skip
      @skip += 1
    end
  end

  def string
    @string.rotate(-@total_rotation)
  end

  def dense_hash
    string.each_slice(16).map do |set|
      set.inject(&:^)
    end
  end

  def hex
    run(64)
    dense_hash.map{ |n| n.to_s(16).rjust(2, '0') }.join
  end
end

def paint(boolean_line, place, n)
  return unless boolean_line[place] == true
  boolean_line[place] = n
  nexts = [place-128, place+128]
  nexts << place-1 unless place % 128 == 0
  nexts << place+1 unless place % 128 == 127
  nexts = nexts.select { |i| i >= 0 && i < boolean_line.length }
  nexts.each do |i|
    paint(boolean_line, i, n)
  end
end

input = 'xlqgujun'
# input = 'flqrgnkx'

grid = (0...128).map do |n|
  Knot.from_string("#{input}-#{n}").hex.each_char.map do |hex|
    hex.to_i(16).to_s(2).rjust(4, '0').each_char.map(&:to_i)
  end.flatten
end

puts grid.flatten.inject(&:+)

boolean_line = grid.flatten.map(&:odd?)

num = 0

loop do
  break unless place = boolean_line.index(true)
  num += 1
  paint(boolean_line, place, num)
end

puts num

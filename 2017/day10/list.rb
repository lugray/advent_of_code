input = File.read(File.dirname(__FILE__) + '/input').chomp

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

knot = Knot.new(input.split(",").map(&:to_i))
knot.run
puts knot.string[0..1].inject(&:*)

puts Knot.from_string(input).hex
class Array
  def excise(arr)
    raise ArgumentError unless self.length == 2 && arr.length == 2
    if arr.first > self.last || arr.last < self.first
      [self]
    elsif arr.first <= self.first && arr.last >= self.last
      [nil]
    elsif arr.first > self.first && arr.last < self.last
      [[self.first, arr.first - 1], [arr.last + 1, self.last]]
    elsif arr.first > self.first
      [[self.first, arr.first - 1]]
    else
      [[arr.last + 1, self.last]]
    end
  end
end

class Blacklist
  def initialize(input)
    @input = input.each_line.map(&:strip).reject{ |line| line == "" }.map{ |line| line.split('-').map(&:to_i) }
  end

  def allowed_ranges
    return @allowed_ranges if @allowed_ranges
    valid = [[0,4294967295]]
    @input.each do |disallowed|
      valid.map! { |range| range.excise(disallowed) }.flatten!(1).compact!
    end
    @allowed_ranges = valid
  end

  def low_allowed
    allowed_ranges.first.first
  end

  def num_allowed
    allowed_ranges.map{ |range| range.last - range.first + 1 }.inject(:+)
  end
end

list = Blacklist.new(File.open(File.dirname(__FILE__) + '/input.txt').read)
puts list.low_allowed
puts list.num_allowed
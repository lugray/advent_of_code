class Generator
  def self.values(prev, factor, req_mult = 1)
    new(prev, factor, req_mult).each
  end

  def initialize(prev, factor, req_mult = 1)
    @prev = prev
    @factor = factor
    @req_mult = req_mult
  end

  def each
    return enum_for(:each) unless block_given?
    prev = @prev
    loop do
      prev = (prev * @factor % 2147483647)
      yield prev if (prev % @req_mult).zero?
    end
  end
end

def count_same(a, b, n)
  count = 0
  n.times do |i|
    count += 1 if a.next & (2**16-1) == b.next & (2**16-1)
  end
  count
end


puts count_same(
  Generator.values(873, 16807),
  Generator.values(583, 48271),
  40_000_000,
)

puts count_same(
  Generator.values(873, 16807, 4),
  Generator.values(583, 48271, 8),
  5_000_000,
)

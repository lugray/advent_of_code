class Salesman
  def initialize(input)
    @dist = {}
    @places = []
    input.each_line.map(&:strip).reject{ |line| line == "" }.each do |line|
      parts = line.scan(/([a-zA-Z]+) to ([a-zA-Z]+) = (\d+)/).first
      @dist["#{parts[0]}:#{parts[1]}"] = parts[2].to_i
      @dist["#{parts[1]}:#{parts[0]}"] = parts[2].to_i
      @places.push(parts[0])
      @places.push(parts[1])
    end
    @places.uniq!
  end

  def distances
    @places.permutation.map do |ordering|
      (0..ordering.length-2).map do |i|
        @dist["#{ordering[i]}:#{ordering[i+1]}"]
      end.inject(:+)
    end
  end

  def min
    distances.min
  end

  def max
    distances.max
  end
end

salesman = Salesman.new(File.open(File.dirname(__FILE__) + '/input.txt').read)
puts salesman.min
puts salesman.max
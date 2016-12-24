class Dinner
  def initialize(input)
    @happy = Hash.new { 0 }
    @people = []
    input.each_line.map(&:strip).reject{ |line| line == "" }.each do |line|
      if parts = line.scan(/([a-zA-Z]+) would lose (\d+) happiness units by sitting next to ([a-zA-Z]+)./).first
        @happy["#{parts[0]}:#{parts[2]}"] = -parts[1].to_i
        @people.push(parts[0])
      elsif parts = line.scan(/([a-zA-Z]+) would gain (\d+) happiness units by sitting next to ([a-zA-Z]+)./).first
        @happy["#{parts[0]}:#{parts[2]}"] = parts[1].to_i
      else
        raise
      end
      @people.push(parts[0])
    end
    @people.uniq!
  end

  def happiness_of(arrangement)
    arrangement.zip(arrangement.rotate).map do |pair|
      @happy["#{pair.first}:#{pair.last}"] + @happy["#{pair.last}:#{pair.first}"]
    end.inject(:+)
  end

  def maximal_happy
    @people.permutation.map{ |arrangement| happiness_of(arrangement) }.max
  end

  def add_self
    @people.push('Self')
  end
end

dinner = Dinner.new(File.open(File.dirname(__FILE__) + '/input.txt').read)
puts dinner.maximal_happy
dinner.add_self
puts dinner.maximal_happy

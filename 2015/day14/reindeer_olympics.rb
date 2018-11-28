class String
  def to_i_if_i
    if to_i.to_s == self
      to_i
    else
      self
    end
  end
end

class Reindeer
  attr_reader :name
  attr_reader :points

  def initialize(name, speed, flight_time, rest_time)
    @name = name
    @speed = speed
    @flight_time = flight_time
    @rest_time = rest_time
    @points = 0
  end

  def distance(t)
    cycle_time = @flight_time + @rest_time
    cycles = t / cycle_time
    remainder = t - cycles * cycle_time
    remainder_flying = [remainder, @flight_time].min
    @speed * (cycles * @flight_time + remainder_flying)
  end

  def add_point
    @points += 1
  end
end

PARSER = /(\w+) can fly (\d+) km\/s for (\d+) seconds, but then must rest for (\d+) seconds/

input = File.read(File.dirname(__FILE__) + '/input.txt').chomp
reindeer = input.split("\n").map do |line|
  args = line.match(PARSER).captures.map(&:to_i_if_i)
  Reindeer.new(*args)
end

race_time = 2503

winning_dist = reindeer.map { |r| r.distance(race_time) }.max
puts winning_dist

(1..race_time).each do |t|
  best_dist = reindeer.map { |r| r.distance(t) }.max
  reindeer.select { |r| r.distance(t) == best_dist }.each(&:add_point)
end

winning_points = reindeer.map(&:points).max
puts winning_points
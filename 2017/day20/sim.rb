class Particle
  attr_reader :num
  def initialize(line, num)
    @num = num
    vals = line.match(%r{p=<(-?\d+),(-?\d+),(-?\d+)>, v=<(-?\d+),(-?\d+),(-?\d+)>, a=<(-?\d+),(-?\d+),(-?\d+)>}).captures
    @px, @py, @pz, @vx, @vy, @vz, @ax, @ay, @az = *vals.map(&:to_i)
  end

  def tick
    update_v
    update_p
  end

  def update_v
    @vx += @ax
    @vy += @ay
    @vz += @az
  end

  def update_p
    @px += @vx
    @py += @vy
    @pz += @vz
  end

  def p
    [@px, @py, @pz]
  end

  def v
    [@vx, @vy, @vz]
  end

  def a
    [@ax, @ay, @az]
  end

  def manhattan_a
    a.map(&:abs).inject(&:+)
  end
end


input = File.open(File.dirname(__FILE__) + '/input').read.chomp

particles = input.split("\n").each_with_index.map { |line, num| Particle.new(line, num) }
puts particles.min_by(&:manhattan_a).num

i = 0
last_count = particles.count
last_collision = nil
loop do
  i += 1
  particles.each(&:tick)
  particles = particles.group_by(&:p).map { |p, particles| particles.first if particles.count == 1 }.compact
  if particles.count < last_count
    last_count = particles.count
    last_collision = i
  end
  break if last_collision && i > 10 * last_collision
end

puts particles.count
class Assembunny
  INT = /-?\d+/

  def initialize(input)
    @input = input.each_line.map(&:strip).reject{ |line| line == "" }.map{ |line| line.split(' ') }
    @line = 0
    @memory = Hash.new { 0 }
  end

  def run
    while @input[@line] do
      send(*@input[@line])
      @line += 1
    end
    @memory.inspect
  end

  def cpy(from, to)
    case from
    when INT
      from = from.to_i
      @memory[to] = from
    else
      @memory[to] = @memory[from]
    end
  end

  def inc(reg)
    @memory[reg] += 1
  end

  def dec(reg)
    @memory[reg] -= 1
  end

  def jnz(reg, dist)
    return if @memory[reg] == 0 unless INT =~ reg && reg.to_i != 0
    dist = dist.to_i
    @line += dist - 1
  end
end

puts Assembunny.new(File.open(File.dirname(__FILE__) + '/input.txt').read).run
puts Assembunny.new('cpy 1 c
  ' + File.open(File.dirname(__FILE__) + '/input.txt').read).run

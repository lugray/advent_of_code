class Program
  attr_reader :memory, :max_ever

  def initialize
    @memory = Hash.new { |hash, key| hash[key] = 0 }
    @max_ever = 0
  end

  def condition(cond)
    reg, op, val = cond.match(/(\w+) (<=|<|>=|>|==|!=) (-?\d+)/).captures
    val = val.to_i
    memory[reg].public_send(op, val)
  end

  def apply(inst)
    reg, op, val = inst.match(/(\w+) (inc|dec) (-?\d+)/).captures
    val = val.to_i
    case op
    when 'inc'
      memory[reg] += val
    when 'dec'
      memory[reg] -= val
    end
    @max_ever = [@max_ever, memory[reg]].max
  end

  def run(inst)
    inst.each do |line|
      inst, cond = line.match(/(\w+ ..c -?\d+) if (.*)/).captures
      apply(inst) if condition(cond)
    end
  end
end

input = File.read(File.dirname(__FILE__) + '/input').chomp

program = Program.new
program.run(input.split("\n"))

puts program.memory.values.max
puts program.max_ever
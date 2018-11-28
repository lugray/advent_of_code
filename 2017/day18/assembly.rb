class String
  def to_i_if_i
    if to_i.to_s == self
      to_i
    else
      self
    end
  end
end

class Assembly
  attr_reader :memory
  attr_accessor :out_buffer

  def initialize(input)
    @input = input.each_line.map(&:strip).reject{ |line| line == "" }.map{ |line| line.split(' ').map(&:to_i_if_i) }
    @line = 0
    @memory = Hash.new { |h, k| h[k] = 0 }
    @out_buffer = []
  end

  def run
    catch(:rcv) do
      while runnable?
        send(*@input[@line])
        @line += 1
      end
    end
  end

  def runnable?
    @input[@line] && @line >= 0
  end

  def snd(val)
    @out_buffer << val_of(val)
  end

  def set(to, from)
    @memory[to] = val_of(from)
  end

  def add(to, val)
    @memory[to] += val_of(val)
  end

  def mul(to, val)
    @memory[to] *= val_of(val)
  end

  def mod(to, val)
    @memory[to] %= val_of(val)
  end

  def rcv(to)
    return if val_of(to) == 0
    @memory[to] = @out_buffer.last
    throw :rcv
  end

  def jgz(reg, dist)
    return unless val_of(reg) > 0
    @line += val_of(dist) - 1
  end

  def val_of(val)
    case val
    when Integer
      val
    else
      @memory[val]
    end
  end
end

class CommunicatingAssembly < Assembly
  attr_accessor :in_buffer
  attr_reader :sent_count

  def initialize(input, id)
    super(input)
    @memory["p"] = id
    @in_buffer = []
    @waiting_for_rcv = false
    @sent_count = 0
  end

  def run
    @waiting_for_rcv = false
    super
  end

  def blocked_on_rcv?
    @waiting_for_rcv && @in_buffer.empty?
  end

  def rcv(to)
    if @in_buffer.empty?
      @waiting_for_rcv = true
      throw :rcv
    else
      @memory[to] = @in_buffer.shift
    end
  end

  def snd(val)
    super(val)
    @sent_count += 1
  end
end

input = File.open(File.dirname(__FILE__) + '/input').read.chomp
machine = Assembly.new(input)
machine.run
puts machine.out_buffer.last

m0 = CommunicatingAssembly.new(input, 0)
m1 = CommunicatingAssembly.new(input, 1)

while (!(m0.blocked_on_rcv? && m1.blocked_on_rcv?)) && (m0.runnable? || m1.runnable?) do
  m0.run
  m1.in_buffer += m0.out_buffer
  m0.out_buffer = []
  m1.run
  m0.in_buffer += m1.out_buffer
  m1.out_buffer = []
end

puts m1.sent_count

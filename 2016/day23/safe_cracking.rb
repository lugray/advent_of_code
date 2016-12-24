class SafeCracking
  INT = /-?\d+/

  def initialize(input)
    @input = input.each_line.map(&:strip).reject{ |line| line == "" }.map{ |line| line.split(' ') }
    @line = 0
    @memory = Hash.new { 0 }
  end

  def mult_memo
    return @mult_memo if @mult_memo
    @mult_memo = 'cpy b c
inc a
dec c
jnz c -2
dec d
jnz d -5'.each_line.map(&:strip).reject{ |line| line == "" }.map{ |line| line.split(' ') }
  end

  def run
    while @input[@line]
      if @input[@line, 6] == mult_memo
        @memory['a'] += @memory['b'] * @memory['d']
        @memory['c'] = 0
        @memory['d'] = 0
        @line += 6
      else
        send(*@input[@line])
        @line += 1
      end
    end
    @memory.inspect
  end

  def input
    @input
  end

  def cpy(from, to)
    return if INT =~ to
    @memory[to] = val_of(from)
  end

  def inc(reg)
    @memory[reg] += 1
  end

  def dec(reg)
    @memory[reg] -= 1
  end

  def jnz(reg, dist)
    return if val_of(reg) == 0
    @line += val_of(dist) - 1
  end

  def tgl(x)
    inst = @input[@line + val_of(x)]
    return unless inst
    @input[@line + val_of(x)][0] = if inst.first == 'inc'
      'dec'
    elsif inst.length == 2
      'inc'
    elsif inst[0] == 'jnz'
      'cpy'
    else
      'jnz'
    end
  end

  def val_of(val)
    case val
    when INT
      val.to_i
    else
      @memory[val]
    end
  end
end

safe = SafeCracking.new('cpy 7 a
  ' + File.open(File.dirname(__FILE__) + '/input.txt').read)
puts safe.run

safe = SafeCracking.new('cpy 12 a
  ' + File.open(File.dirname(__FILE__) + '/input.txt').read)
puts safe.run

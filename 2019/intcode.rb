class Intcode
  def initialize(opcodes)
    @opcodes = opcodes
  end

  def initialize_copy(_)
    @opcodes = @opcodes.dup
  end

  def with(replacements)
    replacements.each do |at, to|
      @opcodes[at] = to
    end
    self
  end

  def with_inputs(*inputs)
    @inputs = inputs
    self
  end

  def run
    @pointer = 0
    loop do
      case @opcodes[@pointer] % 100
      when 1
        @opcodes[@opcodes[@pointer + 3]] = param(0) + param(1)
        @pointer += 4
      when 2
        @opcodes[@opcodes[@pointer + 3]] = param(0) * param(1)
        @pointer += 4
      when 99
        break
      else
        raise "Unexpected opcode"
      end
    end
    self
  end

  def value_at(n)
    @opcodes[n]
  end

  private

  def param(n)
    mode = @opcodes[@pointer].digits[n+2].to_i
    case mode
    when 0
      @opcodes[@opcodes[@pointer+1+n]]
    when 1
      @opcodes[@pointer+1+n]
    end
  end
end

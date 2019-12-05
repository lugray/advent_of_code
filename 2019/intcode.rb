class Intcode
  OPT_ADD = 1
  OPT_MULTIPLY = 2
  OPT_INPUT = 3
  OPT_OUTPUT = 4
  OPT_JUMP_IF_TRUE = 5
  OPT_JUMP_IF_FALSE = 6
  OPT_LESS_THAN = 7
  OPT_EQUALS = 8

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
      when OPT_ADD
        set_param(3, param(0) + param(1))
        @pointer += 4
      when OPT_MULTIPLY
        set_param(3, param(0) * param(1))
        @pointer += 4
      when OPT_INPUT
        set_param(1, @inputs.shift)
        @pointer += 2
      when OPT_OUTPUT
        puts param(0)
        @pointer += 2
      when OPT_JUMP_IF_TRUE
        if param(0) != 0
          @pointer = param(1)
        else
          @pointer += 3
        end
      when OPT_JUMP_IF_FALSE
        if param(0) == 0
          @pointer = param(1)
        else
          @pointer += 3
        end
      when OPT_LESS_THAN
        set_param(3, param(0) < param(1) ? 1 : 0)
        @pointer += 4
      when OPT_EQUALS
        set_param(3, param(0) == param(1) ? 1 : 0)
        @pointer += 4
      when 99
        break
      else
        raise "Unexpected opcode: #{@opcodes[@pointer]}"
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

  def set_param(n, val)
    @opcodes[@opcodes[@pointer + n]] = val
  end
end

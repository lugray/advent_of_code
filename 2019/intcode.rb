class Intcode
  OPT_ADD = 1
  OPT_MULTIPLY = 2
  OPT_INPUT = 3
  OPT_OUTPUT = 4
  OPT_JUMP_IF_TRUE = 5
  OPT_JUMP_IF_FALSE = 6
  OPT_LESS_THAN = 7
  OPT_EQUALS = 8
  OPT_ADJUST_RELATIVE_BASE = 9
  OPT_BREAK = 99

  attr_reader :outputs

  def initialize(opcodes)
    @opcodes = Hash.new { 0 }.merge((0...opcodes.length).zip(opcodes).to_h)
    @pointer = 0
    @done = false
    @inputs = []
    @outputs = []
    @relative_base = 0
  end

  def initialize_copy(_)
    @pointer = 0
    @opcodes = @opcodes.dup
  end

  def with(replacements)
    replacements.each do |at, to|
      @opcodes[at] = to
    end
    self
  end

  def with_inputs(*inputs)
    @inputs += inputs
    self
  end

  def run(until_output: false)
    loop do
      case @opcodes[@pointer] % 100
      when OPT_ADD
        set_param(3, param(1) + param(2))
        @pointer += 4
      when OPT_MULTIPLY
        set_param(3, param(1) * param(2))
        @pointer += 4
      when OPT_INPUT
        break if @inputs.empty?
        set_param(1, @inputs.shift)
        @pointer += 2
      when OPT_OUTPUT
        @outputs.push(param(1))
        @pointer += 2
        break if until_output
      when OPT_JUMP_IF_TRUE
        if param(1) != 0
          @pointer = param(2)
        else
          @pointer += 3
        end
      when OPT_JUMP_IF_FALSE
        if param(1) == 0
          @pointer = param(2)
        else
          @pointer += 3
        end
      when OPT_LESS_THAN
        set_param(3, param(1) < param(2) ? 1 : 0)
        @pointer += 4
      when OPT_EQUALS
        set_param(3, param(1) == param(2) ? 1 : 0)
        @pointer += 4
      when OPT_BREAK
        @done = true
        break
      when OPT_ADJUST_RELATIVE_BASE
        @relative_base += param(1)
        @pointer += 2
      else
        raise "Unexpected opcode: #{@opcodes[@pointer]}"
      end
    end
    self
  end

  def done?
    @done
  end

  def value_at(n)
    @opcodes[n]
  end

  private

  def param(n)
    mode = @opcodes[@pointer].digits[n+1].to_i
    case mode
    when 0
      @opcodes[@opcodes[@pointer + n]]
    when 1
      @opcodes[@pointer + n]
    when 2
      @opcodes[@relative_base + @opcodes[@pointer + n]]
    end
  end

  def set_param(n, val)
    mode = @opcodes[@pointer].digits[n+1].to_i
    case mode
    when 0
      @opcodes[@opcodes[@pointer + n]] = val
    when 1
      @opcodes[@pointer + n] = val
    when 2
      @opcodes[@relative_base + @opcodes[@pointer + n]] = val
    end
  end
end

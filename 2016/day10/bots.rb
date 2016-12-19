class Bots
  EXACT = /^value (\d+) goes to bot (\d+)$/
  COMPARE_BOT_BOT = /^bot (\d+) gives low to bot (\d+) and high to bot (\d+)$/
  COMPARE_BOT_OUT = /^bot (\d+) gives low to bot (\d+) and high to output (\d+)$/
  COMPARE_OUT_BOT = /^bot (\d+) gives low to output (\d+) and high to bot (\d+)$/
  COMPARE_OUT_OUT = /^bot (\d+) gives low to output (\d+) and high to output (\d+)$/

  def initialize(input)
    @input = input.each_line.map(&:strip).reject{ |line| line == "" }
    @bot_gets=Array.new
    @out_gets=Array.new(3)
  end

  def run_once
    @input.each do |instruction|
      if numbers = instruction.scan(EXACT).first
        value, to_bot = *numbers.map(&:to_i)
        add_value_to_bot(value, to_bot)
      elsif numbers = instruction.scan(COMPARE_BOT_BOT).first
        from_bot, low_to_bot, high_to_bot = *numbers.map(&:to_i)
        if @bot_gets[from_bot] && @bot_gets[from_bot].size == 2
          add_value_to_bot(@bot_gets[from_bot].min, low_to_bot)
          add_value_to_bot(@bot_gets[from_bot].max, high_to_bot)
        end
      elsif numbers = instruction.scan(COMPARE_BOT_OUT).first
        from_bot, low_to_bot, high_to_out = *numbers.map(&:to_i)
        if @bot_gets[from_bot] && @bot_gets[from_bot].size == 2
          add_value_to_bot(@bot_gets[from_bot].min, low_to_bot)
          add_value_to_out(@bot_gets[from_bot].max, high_to_out)
        end
      elsif numbers = instruction.scan(COMPARE_OUT_BOT).first
        from_bot, low_to_out, high_to_bot = *numbers.map(&:to_i)
        if @bot_gets[from_bot] && @bot_gets[from_bot].size == 2
          add_value_to_out(@bot_gets[from_bot].min, low_to_out)
          add_value_to_bot(@bot_gets[from_bot].max, high_to_bot)
        end
      elsif numbers = instruction.scan(COMPARE_OUT_OUT).first
        from_bot, low_to_out, high_to_out = *numbers.map(&:to_i)
        if @bot_gets[from_bot] && @bot_gets[from_bot].size == 2
          add_value_to_out(@bot_gets[from_bot].min, low_to_out)
          add_value_to_out(@bot_gets[from_bot].max, high_to_out)
        end
      end
    end
  end

  def run_to_ans_a
    while !@bot_gets.any? { |compares| compares == [17, 61] } do
      run_once
    end
    @bot_gets.index([17, 61])
  end

  def run_to_ans_b
    while @out_gets.first(3).any? { |val| val.nil? } do
      run_once
    end
    @out_gets.first(3).inject(:*)
  end

  def add_value_to_bot(value, bot)
    @bot_gets[bot] = Array.new unless @bot_gets[bot]
    @bot_gets[bot] << value
    @bot_gets[bot].uniq!
    @bot_gets[bot].sort!
  end

  def add_value_to_out(value, out)
    @out_gets[out] = value
  end
end

puts Bots.new(File.open(File.dirname(__FILE__) + '/input.txt').read).run_to_ans_a
puts Bots.new(File.open(File.dirname(__FILE__) + '/input.txt').read).run_to_ans_b

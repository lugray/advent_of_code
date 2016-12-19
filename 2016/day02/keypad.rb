require 'matrix'

class Keypad
  KEYPAD_A=[
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
  ]
  KEYPAD_B = [
    [nil, nil, 1],
    [nil, 2, 3, 4],
    [5, 6, 7, 8, 9],
    [nil, "A", "B", "C"],
    [nil, nil, "D"],
  ]
  def initialize(weird_keypad = false)
    if weird_keypad
      @keypad = KEYPAD_B
      @position = Vector[2,0]
    else
      @keypad = KEYPAD_A
      @position = Vector[1,1]
    end
    @code = ""
  end

  def process(input)
    input.each_line do |line|
      line.each_char do |char|
        move(char)
      end
      add_to_code
    end
    @code
  end

  private

  def move(instruction)
    vector = case instruction
    when "U"
      Vector[-1, 0]
    when "D"
      Vector[1, 0]
    when "L"
      Vector[0, -1]
    when "R"
      Vector[0, 1]
    else
      Vector[0, 0]
    end
    @position = @position + vector if allowed?(@position + vector)
  end

  def char_at(pos)
    return nil if pos[0] < 0
    return nil if pos[1] < 0
    return nil unless @keypad[pos[0]]
    @keypad[pos[0]][pos[1]]
  end

  def allowed?(pos)
    !char_at(pos).nil?
  end

  def add_to_code
    @code += char_at(@position).to_s
  end
end

puts Keypad.new.process(File.open(File.dirname(__FILE__) + '/input.txt').read)
puts Keypad.new(true).process(File.open(File.dirname(__FILE__) + '/input.txt').read)

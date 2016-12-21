class Password

  SCRAMBLERS = [
    /(swap position) (\d+) with position (\d+)/,
    /(swap letter) ([a-zA-Z]+) with letter ([a-zA-Z]+)/,
    /(rotate left) (\d+) step/,
    /(rotate right) (\d+) step/,
    /(rotate based on position of letter) ([a-zA-Z]+)/,
    /(reverse positions) (\d+) through (\d+)/,
    /(move position) (\d+) to position (\d+)/,
  ]

  def initialize(input)
    @input = input.each_line.map(&:strip).reject{ |line| line == "" }
  end

  def scramble(password)
    output = password
    @input.each { |instruction| output = scramble_step(instruction, output) }
    output
  end

  private

  def scramble_step(instruction, password)
    scrambler = SCRAMBLERS.find { |scrambler| scrambler =~ instruction }
    instruction_parts = instruction.scan(scrambler).first
    normalize_parts!(instruction_parts)
    instruction_parts.push(password.dup)
    send(*instruction_parts)
  end

  def normalize_parts!(parts)
    parts.map! do |part|
      if /^\d+$/ =~ part
        part.to_i
      elsif part[' ']
        part.gsub(' ', '_').to_sym
      else
        part
      end
    end
  end

  def swap_position(i, j, password)
    l1 = password[i]
    l2 = password[j]
    password[i] = l2
    password[j] = l1
    password
  end

  def swap_letter(a, b, password)
    swap_position(password.index(a), password.index(b), password)
  end

  def rotate_left(n, password)
    password[n, password.length] + password[0, n]
  end

  def rotate_right(n, password)
    rotate_left(password.length-n, password)
  end

  def rotate_based_on_position_of_letter(a, password)
    n = password.index(a)
    password = rotate_right(n+1, password)
    n >= 4 ? rotate_right(1, password) : password
  end

  def reverse_positions(i, j, password)
    password[0, i] + password[i, j - i + 1].reverse + password[j + 1, password.length]
  end

  def move_position(i, j, password)
    l = password[i]
    interim = password[0, i] + password[i+1, password.length]
    interim[0, j] + l + interim[j, password.length]
  end
end

pass = Password.new(File.open(File.dirname(__FILE__) + '/input.txt').read)
puts pass.scramble('abcdefgh')
puts 'fbgdceah'.each_char.to_a.permutation.find { |letters| pass.scramble(letters.join) == 'fbgdceah'}.join


class Screen
  def initialize(input)
    @input = input.each_line.map(&:strip).reject{ |line| line == "" }.map{ |line| commandify(line)}
    @screen = Array.new(6) { Array.new(50) {false} }
  end

  def run
    @input.each do |command|
      send(command.first, *command.last.map(&:to_i))
    end
    self
  end

  def screen
    puts @screen.map{ |row| row.map { |el| el ? '▮' : ' ' }.join }.join("\n")
  end

  def count
    @screen.flatten.count(true)
  end

  def rect(w, h)
    w.times do |x|
      h.times do |y|
        @screen[y][x] = true
      end
    end
  end

  def rot_row(row_index, dist)
    @screen[row_index].rotate!(-dist)
  end

  def rot_col(col_index, dist)
    @screen = @screen.transpose
    rot_row(col_index, dist)
    @screen = @screen.transpose
  end

  def commandify(str)
    case str
    when /^rect/
      [:rect, str.scan(/(\d+)x(\d+)/).first]
    when /^rotate row/
      [:rot_row, str.scan(/(\d+) by (\d+)/).first]
    when /^rotate column/
      [:rot_col, str.scan(/(\d+) by (\d+)/).first]
    end
  end
end

puts Screen.new(File.open(File.dirname(__FILE__) + '/input.txt').read).run.count
puts Screen.new(File.open(File.dirname(__FILE__) + '/input.txt').read).run.screen

require 'matrix'

class Turtle
  CLOCKWISE = Matrix[[0, 1], [-1, 0]]
  COUNTER_CLOCKWISE = Matrix[[0, -1], [1, 0]]
  TEXT_NUMBER_BOUNDARY = /(?<!\d)(?=\d)/

  attr_accessor :position

  def initialize(stop_on_return = false)
    @position = Vector[0, 0]
    @facing = Vector[0, 1]
    @visited = [@position]
    @stop_on_return = stop_on_return
  end

  def move(input)
    input.split(',').map(&:strip).each { |instruction| single_move(instruction)}
  end

  def taxi_distance
    position.map(&:abs).inject(:+)
  end

  private

  def single_move(instruction)
    split_instruction = instruction.split(TEXT_NUMBER_BOUNDARY)
    rotate(split_instruction.first)
    advance(split_instruction.last.to_i)
  end

  def rotate(dir)
    case dir
    when "R"
      @facing = CLOCKWISE * @facing
    when "L"
      @facing = COUNTER_CLOCKWISE * @facing
    end
  end

  def advance(distance)
    distance.times { step }
  end

  def step
    return if @stop_on_return && @visited.first(@visited.size-1).include?(@position)
    @position += @facing
    @visited << @position
  end
end

puts Turtle.new.tap { |turtle| turtle.move(File.open(File.dirname(__FILE__) + '/input.txt').read) }.taxi_distance
puts Turtle.new(true).tap { |turtle| turtle.move(File.open(File.dirname(__FILE__) + '/input.txt').read) }.taxi_distance

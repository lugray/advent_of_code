class ChristmasLights
  def initialize(input, dimmable = false)
    @dimmable = dimmable
    @instructions = input.each_line.map(&:strip).reject{ |line| line == "" }.map do |instruction|
      method_name = instruction.scan(/(^[a-z ]+) /).first.first
      corners = instruction.scan(/([\d,]+) through ([\d,]+)/).first.map{ |corner| corner.split(',').map(&:to_i) }.flatten
      corners.unshift(method_name)
    end
    @lights = Array.new(1000) { Array.new(1000) {@dimmable ? 0 : false} }
  end

  def follow_instructions
    @instructions.each do |instruction|
      follow_instruction(*instruction)
    end
    self
  end

  def follow_instruction(method_name, x_min, y_min, x_max, y_max)
    (x_min..x_max).each do |x|
      (y_min..y_max).each do |y|
        @lights[x][y] = case method_name
        when 'turn on'
          if @dimmable
            @lights[x][y] + 1
          else
            true
          end
        when 'turn off'
          if @dimmable
            @lights[x][y] - 1
          else
            false
          end
        when 'toggle'
          if @dimmable
            @lights[x][y] + 2
          else
            !@lights[x][y]
          end
        else
          raise
        end
        if @dimmable
          @lights[x][y] = [@lights[x][y],0].max
        end
      end
    end
    self
  end

  def count_lit
    if @dimmable
      @lights.flatten.inject(:+)
    else
      @lights.flatten.count(true)
    end
  end
end

lights = ChristmasLights.new(File.open(File.dirname(__FILE__) + '/input.txt').read)
puts lights.follow_instructions.count_lit
lights = ChristmasLights.new(File.open(File.dirname(__FILE__) + '/input.txt').read, true)
puts lights.follow_instructions.count_lit
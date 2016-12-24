class Computing
  def initialize(input)
    @input = input.each_line.map(&:strip).reject{ |line| !line["/dev/grid/node"] }.map do |line|
      line.scan(/node-x(\d+)-y(\d+) +(\d+)T +(\d+)T +(\d+)T/).first.map(&:to_i)
    end
  end

  def viable_pairs
    @input.product(@input).find_all do |pair|
      pair.first[3] > 0 &&
      pair.first != pair.last &&
      pair.first[3] <= pair.last[4]
    end
  end

  def simple_rep
    return @simple_rep if @simple_rep
    @simple_rep = Array.new(max_y + 1) { Array.new(max_x + 1) }
    @input.each do |node|
      @simple_rep[node[1]][node[0]] = if node[3] == 0
        'O'
      elsif node[3] < 100
        '.'
      else
        '#'
      end
    end
    simple_rep
  end

  def max_y
    @input.map{ |node| node[1] }.max
  end

  def max_x
    @input.map{ |node| node[0] }.max
  end
end

computing = Computing.new(File.open(File.dirname(__FILE__) + '/input.txt').read)
puts computing.viable_pairs.length
puts computing.simple_rep.map(&:join)
puts 29+30*5

class Cubicles
  def initialize(fav_num)
    @fav_num = fav_num.to_i
    @is_wall = Hash.new { |hash, x| hash[x] = Hash.new { |inner_hash, y| inner_hash[y] = is_wall_calc(x, y) } }
    @wall_for_num = Hash.new { |hash, num| hash[num] = wall_for_num_calc(num) }
    @start_pos = [1, 1]
    @end_pos = [31, 39]
    @visited = []
  end

  def is_wall_calc(x, y)
    return true if x < 0 || y < 0
    num = x*x + 3*x + 2*x*y + y + y*y + @fav_num
    @wall_for_num[num]
  end

  def wall_for_num_calc(num)
    num.to_s(2).scan('1').length.odd?
  end

  def shortest_path(positions = [@start_pos])
    return 0 if positions.any? { |pos| pos == @end_pos}
    @visited = @visited | positions
    next_possible = positions.map do |position|
      x, y = *position
      [[x+1, y], [x, y+1], [x-1, y], [x, y-1]]
    end.flatten(1).uniq
    next_possible = next_possible - @visited
    next_possible.reject! do |new_pos|
      new_x, new_y = *new_pos
      @is_wall[new_x][new_y]
    end
    1 + shortest_path(next_possible)
  end

  def reachable_in(steps_left, positions = [@start_pos])
    @visited = @visited | positions
    return @visited.length if steps_left == 0
    next_possible = positions.map do |position|
      x, y = *position
      [[x+1, y], [x, y+1], [x-1, y], [x, y-1]]
    end.flatten(1).uniq
    next_possible = next_possible - @visited
    next_possible.reject! do |new_pos|
      new_x, new_y = *new_pos
      @is_wall[new_x][new_y]
    end
    reachable_in(steps_left - 1, next_possible)
  end

  def show_map(max_x, max_y)
    max_y.times do |y|
      line = ""
      max_x.times do |x|
        line += @is_wall[x][y] ? '#' : " "
      end
      puts line
    end
    nil
  end
end

puts Cubicles.new('1350').shortest_path
puts Cubicles.new('1350').reachable_in(50)

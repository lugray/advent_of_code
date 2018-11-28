class Life
  def initialize(grid, corners_on: false)
    @grid = grid
    @corners_on = corners_on
  end

  def grid
    if @corners_on
      @grid[0][0] = true
      @grid[-1][0] = true
      @grid[0][-1] = true
      @grid[-1][-1] = true
    end
    @grid
  end

  def show
    display_array = grid.map do |row|
      row.map {|living| living ? "#" : "." }.join
    end
    puts display_array
    puts ""
  end

  def count_living
    grid.flatten.count { |i| i }
  end

  def step(n = 1)
    if n > 1
      n.times { step }
      return
    end
    @grid = grid.each_with_index.map do |row, i|
      row.each_with_index.map do |cell, j|
        neighbour_count = (i-1..i+1).map do |ii|
          (j-1..j+1).map do |jj|
            if ii == i && jj == j
              0
            elsif ii < 0
              0
            elsif jj < 0
              0
            elsif grid.dig(ii,jj)
              1
            else
              0
            end
          end.inject(&:+)
        end.inject(&:+)
        if cell && neighbour_count == 2
          true
        elsif neighbour_count == 3
          true
        else
          false
        end
      end
    end
  end
end

input = File.read(File.dirname(__FILE__) + '/input.txt')

# input = '.#.#.#
# ...##.
# #....#
# ..#...
# #.#..#
# ####..'

grid = input.split("\n").map do |line|
  line.each_char.map {|cell| cell == "#" }
end
life = Life.new(grid)
life.step(100)
puts life.count_living

life = Life.new(grid, corners_on: true)
life.step(100)
puts life.count_living


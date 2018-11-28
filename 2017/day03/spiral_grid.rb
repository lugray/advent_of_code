input = 347991
# input = 1024
input = 12
def dist(input)
  box_size = Math.sqrt(input).floor
  box_size = box_size.even? ? box_size - 1 : box_size
  return 2 * box_size - 1 if box_size ** 2 == input
  base_dist = box_size + 1
  full_side = box_size + 1
  left = input - box_size ** 2
  left_on_side = left % (full_side)

  max_sub = full_side / 2
  # puts box_size
  # puts left
  # puts left_on_side
  # puts base_dist
  base_dist - (max_sub - (max_sub - left_on_side).abs)
end

puts dist(12)
puts dist(16)
puts dist(23)
puts dist(347991)


grid = Hash.new { |hash, key| hash[key] = Hash.new(0) }

grid[0][0] = 1

def write_grid(x, y, grid)
  grid[x][y] = (x-1..x+1).map { |x1| (y-1..y+1).map { |y1| grid[x1][y1] }.inject(&:+) }.inject(&:+)
  if grid[x][y] > 347991
    puts grid[x][y]
    exit
  end
end

def show(grid)
  # require 'byebug'; byebug
  max_x = grid.keys.max
  max_y = grid.values.first.keys.max
  (-max_y..max_y).each do |y|
    (-max_x..max_x).each do |x|
      print grid[x][y]
      print " "
    end
    puts
  end
end



(1..Float::INFINITY).step(2) do |box_size|
  box_size = box_size.round
  x = (box_size + 1)/2
  y = -(box_size + 1)/2
  (box_size+1).times do
    y += 1
    write_grid(x, y, grid)
  end
  (box_size+1).times do
    x -= 1
    write_grid(x, y, grid)
  end
  (box_size+1).times do
    y -= 1
    write_grid(x, y, grid)
  end
  (box_size+1).times do
    x += 1
    write_grid(x, y, grid)
  end
  # show(grid)
  # sleep 1
end
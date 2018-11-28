class Array
  def inner_reverse
    map(&:reverse)
  end
end

def flip_rots_op_sequences
  @flip_rots_op_sequences ||= begin
    orig = [[:a,:b,:c],[:d,:e,:f],[:g,:h,:i]]
    ops = [:transpose, :transpose, :transpose, :inner_reverse, :reverse]
    op_lists = (1...ops.length).map { |n| ops.combination(n).to_a }.flatten(1).uniq.map { |l| l.permutation.to_a }.flatten(1)
    results = op_lists.map { |l| [l.inject(orig, :send), l] }
    groups = results.group_by { |pair| pair.first.flatten.join }
    groups.delete(orig.flatten.join)
    flip_rots_op_sequences = groups.map { |_, list| list.map(&:last).sort_by(&:length).first }
  end
end

def rules(input)
  @rules ||= {}
  @rules[input] ||= begin
    rules = input.split("\n").map do |line|
      line.split(' => ').map do |grid_string|
        grid_string.split("/").map do |row|
          row.each_char.map do |c|
            c == "#"
          end
        end
      end
    end.to_h

    rules.keys.each do |key|
      alt_keys = flip_rots_op_sequences.map { |op_sequence| op_sequence.inject(key, :send) }
      alt_keys.each do |alt_key|
        rules[alt_key] = rules[key]
      end
    end
    rules
  end
end

def display(grid)
  grid.map do |row|
    row.map do |c|
      c ? "#" : "."
    end.join
  end.join("\n")
end

def split(grid)
  sub_size = grid.size % 2 == 0 ? 2 : 3
  grid.each_slice(sub_size).map do |semi_sub|
    semi_sub.transpose.each_slice(sub_size).map(&:transpose)
  end
end

def join(sub_grids)
  sub_grids.map do |semi_sub|
    semi_sub.map(&:transpose).flatten(1).transpose
  end.flatten(1)
end

input = File.open(File.dirname(__FILE__) + '/input').read.chomp

test_input = '../.# => ##./#../...
.#./..#/### => #..#/..../..../#..#'

grid = [
  [false, true, false],
  [false, false, true],
  [true, true, true],
]

def iterate_grid(grid, input, iterations=1, verbose = false)
  iterations.times do
    sub_grids = split(grid)
    sub_grids = sub_grids.map do |semi_sub|
      semi_sub.map do |sub_grid|
        rules(input)[sub_grid]
      end
    end
    grid = join(sub_grids)
    if verbose
      puts display(grid)
      puts "--"
    end
  end
  grid
end

# puts iterate_grid(grid, test_input, 2).flatten.count {|c| c}
puts iterate_grid(grid, input, 5).flatten.count {|c| c}
puts iterate_grid(grid, input, 18).flatten.count {|c| c}



class Elevator
  def initialize(init_pairs)
    @start_pos = [1, init_pairs.sort]
    @end_pos = [4, [[4,4]]*@start_pos.last.size]
    @visited = []
  end

  def fried_chips(position)
    pairs = position.last
    pairs.any? do |pair|
      if pair.first == pair.last
        false
      else
        other_pairs = get_other_pairs(pairs, pair)
        other_pairs.map(&:last).any? { |generator| generator == pair.first }
      end
    end
  end

  def get_other_pairs(pairs, pair)
    other_pairs = pairs.dup
    other_pairs.delete_at(other_pairs.find_index(pair))
    other_pairs
  end

  def next_position_set_from(position)
    elevator = position.first
    pairs = position.last
    next_positions = []
    if elevator > 1
      pairs.each do |pair|
        other_pairs = get_other_pairs(pairs, pair)
        if pair.first == elevator
          next_positions.push([elevator-1,other_pairs.dup.push([pair.first-1, pair.last]).sort])
        end
        if pair.last == elevator
          next_positions.push([elevator-1,other_pairs.dup.push([pair.first, pair.last-1]).sort])
        end
        if pair.first == elevator && pair.last == elevator
          next_positions.push([elevator-1,other_pairs.dup.push([pair.first-1, pair.last-1]).sort])
        end
        other_pairs.each do |second_pair|
          remaining_pairs = get_other_pairs(other_pairs, second_pair)
          if pair.first == elevator
            if second_pair.first == elevator
              next_positions.push([elevator-1,remaining_pairs.dup.push([pair.first-1, pair.last]).push([second_pair.first-1, second_pair.last]).sort])
            end
            if second_pair.last == elevator
              next_positions.push([elevator-1,remaining_pairs.dup.push([pair.first-1, pair.last]).push([second_pair.first, second_pair.last-1]).sort])
            end
          end
          if pair.last == elevator
            if second_pair.first == elevator
              next_positions.push([elevator-1,remaining_pairs.dup.push([pair.first, pair.last-1]).push([second_pair.first-1, second_pair.last]).sort])
            end
            if second_pair.last == elevator
              next_positions.push([elevator-1,remaining_pairs.dup.push([pair.first, pair.last-1]).push([second_pair.first, second_pair.last-1]).sort])
            end
          end
        end
      end
    end
    if elevator < 4
      pairs.each do |pair|
        other_pairs = get_other_pairs(pairs, pair)
        if pair.first == elevator
          next_positions.push([elevator+1,other_pairs.dup.push([pair.first+1, pair.last]).sort])
        end
        if pair.last == elevator
          next_positions.push([elevator+1,other_pairs.dup.push([pair.first, pair.last+1]).sort])
        end
        if pair.first == elevator && pair.last == elevator
          next_positions.push([elevator+1,other_pairs.dup.push([pair.first+1, pair.last+1]).sort])
        end
        other_pairs.each do |second_pair|
          remaining_pairs = get_other_pairs(other_pairs, second_pair)
          if pair.first == elevator
            if second_pair.first == elevator
              next_positions.push([elevator+1,remaining_pairs.dup.push([pair.first+1, pair.last]).push([second_pair.first+1, second_pair.last]).sort])
            end
            if second_pair.last == elevator
              next_positions.push([elevator+1,remaining_pairs.dup.push([pair.first+1, pair.last]).push([second_pair.first, second_pair.last+1]).sort])
            end
          end
          if pair.last == elevator
            if second_pair.first == elevator
              next_positions.push([elevator+1,remaining_pairs.dup.push([pair.first, pair.last+1]).push([second_pair.first+1, second_pair.last]).sort])
            end
            if second_pair.last == elevator
              next_positions.push([elevator+1,remaining_pairs.dup.push([pair.first, pair.last+1]).push([second_pair.first, second_pair.last+1]).sort])
            end
          end
        end
      end
    end
    next_positions
  end

  def shortest_path(positions = [@start_pos])
    return 0 if positions.any? { |pos| pos == @end_pos}
    @visited = @visited | positions
    next_possible = positions.map do |position|
      next_position_set_from(position)
    end.flatten(1).uniq
    next_possible = next_possible - @visited
    next_possible.reject! do |new_pos|
      fried_chips(new_pos)
    end
    1 + shortest_path(next_possible)
  end
end

puts Elevator.new([[1,1], [2,1], [2,1], [3,3], [3,3]]).shortest_path
puts Elevator.new([[1,1], [1,1], [1,1], [2,1], [2,1], [3,3], [3,3]]).shortest_path

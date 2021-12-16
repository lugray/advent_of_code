#!/usr/bin/env ruby

require_relative 'day'

class Day15 < Day
  class SortedList < Array
    def initialize(arr, &sort_by_fn)
      @sort_by_fn = sort_by_fn
      replace(arr.sort_by(&@sort_by_fn))
    end

    def <<(elem)
      elem_sort_val = @sort_by_fn.call(elem)
      i = bsearch_index do |e|
        @sort_by_fn.call(e) > elem_sort_val
      end || size
      insert(i, elem)
    end

    def delete(elem)
      elem_sort_val = @sort_by_fn.call(elem)
      i = bsearch_index do |e|
        @sort_by_fn.call(e) >= elem_sort_val
      end
      return unless i
      loop do
        break delete_at(i) if at(i) == elem
        i += 1
        break if i >= size
        break if @sort_by_fn.call(at(i)) > elem_sort_val
      end
    end
  end

  def initialize
    @risk = input_lines.map do |l|
      l.each_char.map(&:to_i)
    end
  end

  def far_corner_ltr
    @ltr = @risk.map { |l| l.map { Float::INFINITY } }
    @ltr[0][0] = 0
    sx = @ltr.size
    sy = @ltr.first.size
    nodes = SortedList.new([[0,0]]) { |(x, y)| @ltr[x][y] }

    until nodes.empty? do
      node = nodes.shift
      break if node == [sx - 1, sy - 1]
      x, y = node
      [
        [x-1, y],
        [x+1, y],
        [x, y-1],
        [x, y+1],
      ].each do |nx, ny|
        next if nx < 0
        next if ny < 0
        next if nx >= sx
        next if ny >= sy
        next unless @ltr[x][y] + @risk[nx][ny] < @ltr[nx][ny]
        nodes.delete([nx, ny])
        @ltr[nx][ny] = @ltr[x][y] + @risk[nx][ny]
        nodes << [nx, ny]
      end
    end
    @ltr[-1][-1]
  end

  def expand_grid
    sx = @risk.size
    sy = @risk.first.size
    (0...sx).each do |x|
      (0...sy).each do |y|
        (0...5).each do |dx|
          (0...5).each do |dy|
            next if dx == 0 && dy == 0
            @risk[x+dx*sx] ||= []
            @risk[x+dx*sx][y+dy*sy] = ((@risk[x][y] + dx + dy) % 9).nonzero? || 9
          end
        end
      end
    end
  end

  def part_1
    far_corner_ltr
  end

  def part_2
    expand_grid
    far_corner_ltr
  end
end

Day15.run if __FILE__ == $0

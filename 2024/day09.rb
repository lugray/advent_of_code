#!/usr/bin/env ruby

require_relative 'day'

class Day09 < Day
  def initialize
    @disk_map = input.chomp.each_char.map(&:to_i)
  end

  def back(disk_map)
    return enum_for(__method__, disk_map) unless block_given?
    high_id = disk_map.size/2
    disk_map.reverse_each.each_slice(2) do |file_size, _|
      file_size.times do
        yield high_id
      end
    high_id -= 1
    end
  end

  def each_id(disk_map)
    return enum_for(__method__, disk_map) unless block_given?
    disk_map = disk_map.dup
    disk_map.pop if disk_map.size.even?
    b = back(disk_map)
    size = disk_map.each_slice(2).sum(&:first)
    count = 0
    disk_map.each_slice(2).each_with_index do |(file_size, empty_size), i|
      [file_size, size-count].min.times do
        yield i
      end
      count += file_size
      break if count >= size
      [empty_size, size-count].min.times do
        yield b.next
      end
      count += empty_size
      break if count >= size
    end
  end

  def part_1
    each_id(@disk_map).each_with_index.sum { |id, i| id * i }
  end

  def defraged_each_id(disk_map)
    return enum_for(__method__, disk_map) unless block_given?
    disk_map = @disk_map.dup
    disk_map.push(0) if disk_map.size.odd?
    reversed = disk_map.each_slice(2).each_with_index.reverse_each.map { |(file_size, empty_size), id| [file_size, id] }
    done = {}
    count = 0
    disk_map.each_slice(2).each_with_index.each do |(file_size, empty_size), id|
      file_size.times { yield done[id] ? 0 : id }
      done[id] = true
      while empty_size > 0
        break unless r = reversed.find do |file_size2, id2|
          break nil if id2 <= id
          file_size2 <= empty_size && !done[id2]
        end
        file_size2, id2 = r
        file_size2.times { yield id2 }
        done[id2] = true
        empty_size -= file_size2
      end
      empty_size.times do
        yield 0
      end
    end
  end

  def part_2
    defraged_each_id(@disk_map).each_with_index.sum { |id, i| id * i }
  end
end

Day09.run if __FILE__ == $0

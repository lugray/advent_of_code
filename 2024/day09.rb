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

  def part_2
    disk = @disk_map.each_slice(2).each_with_index.flat_map do |(file_size, empty_size), i|
      [[file_size, i], [empty_size, nil]]
    end
    disk.pop
    disk.reverse_each do |size, id|
      next unless id
      j = disk.rindex { |_, i| i == id }
      free_i = disk.find_index { |s, i| s >= size && i.nil? }
      if free_i
        next if free_i > j
        orig_free = disk[free_i].first
        disk[free_i] = [size, id]
        new_free = size
        after = disk[j+1]
        before = disk[j-1]
        if after && after.last.nil?
          new_free += after.first
        end
        if before && before.last.nil?
          new_free += before.first
        end
        disk.insert(j, [new_free, nil])
        if after && after.last.nil?
          disk.delete_at(j+2)
        end
        disk.delete_at(j+1)
        if before && before.last.nil?
          disk.delete_at(j-1)
        end
        disk.insert(free_i+1, [orig_free-size, nil])
      end
    end
    disk.reject! { |size, _| size.zero? }
    start = 0
    disk.sum do |size, id|
      r = if id
        q = size * start + (size - 1) * size / 2
        q * id
      else
        0
      end
      start += size
      r
    end
  end
end

Day09.run if __FILE__ == $0

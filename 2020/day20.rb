#!/usr/bin/env ruby

require_relative 'day'

class Tile
  attr_reader :id

  def initialize(str)
    raise 'wut' unless str.start_with?('Tile ')
    n, pixels = str[5..].split(":\n")
    @id = n.to_i
    @pixels = pixels.each_line(chomp: true).map { |l| l.each_char.map { |c| c == '#' } }
  end

  def borderless
    @pixels[1..-2].map { |l| l[1..-2] }
  end

  def border_ids
    [top, bottom, left, right]
  end

  def border_id(arr)
    [
      arr.each_with_index.sum { |v, i| v ? 2**i : 0 },
      arr.reverse.each_with_index.sum { |v, i| v ? 2**i : 0 },
    ].min
  end

  def top
    border_id(@pixels.first)
  end

  def bottom
    border_id(@pixels.last)
  end

  def left
    border_id(@pixels.map(&:first))
  end

  def right
    border_id(@pixels.map(&:last))
  end

  def rotate
    @pixels = @pixels.transpose.map(&:reverse)
  end

  def flip_h
    @pixels = @pixels.map(&:reverse)
  end

  def flip
    @pixels = @pixels.reverse
  end
end

class Day20 < Day
  MONSTER = <<~MONSTER
                      # 
    #    ##    ##    ###
     #  #  #  #  #  #   
  MONSTER

  MONSTER_COORDS = MONSTER.each_line(chomp: true).each_with_object([]).each_with_index do |(line, arr), r|
    line.each_char.with_index do |char, c|
      arr << [r, c] if char == '#'
    end
  end

  MONSTER_HEIGHT = MONSTER.each_line(chomp: true).to_a.size
  MONSTER_WIDTH = MONSTER.each_line(chomp: true).max_by(&:size).size

  def initialize
    @tiles = input.split("\n\n").map { |t| Tile.new(t) }
  end

  def remove_tile(tile_set, &block)
    index = tile_set.find_index(&block)
    return nil unless index
    tile = tile_set[index]
    tile_set.delete_at(index)
    tile
  end

  def mark_monsters(image)
    found = false
    (0..(image.size - MONSTER_HEIGHT)).each do |r|
      (0..(image.first.size - MONSTER_WIDTH)).each do |c|
        if MONSTER_COORDS.all? { |dr, dc| image[r + dr][c + dc] }
          found = true
          MONSTER_COORDS.each { |dr, dc| image[r + dr][c + dc] = 1 }
        end
      end
    end
    puts found
  end

  def part_1
    outer_border_ids = @tiles.flat_map(&:border_ids).sort.chunk(&:itself).map(&:last).select { |a| a.size == 1}.map(&:first)
    @tiles.select do |tile|
      (tile.border_ids & outer_border_ids).size == 2
    end.map(&:id).inject(&:*)
  end

  def part_2
    outer_border_ids = @tiles.flat_map(&:border_ids).sort.chunk(&:itself).map(&:last).select { |a| a.size == 1}.map(&:first)
    remaining_tiles = @tiles.dup
    tile = remove_tile(remaining_tiles) { |tile| (tile.border_ids & outer_border_ids).size == 2 }
    until ([tile.left, tile.top] & outer_border_ids).size == 2
      tile.rotate
    end
    image = [[tile]]
    last = tile
    loop do
      while tile = remove_tile(remaining_tiles) { |tile| tile.border_ids.include?(last.right) }
        until tile.left == last.right
          tile.rotate
        end
        if image.size == 1
          tile.flip unless outer_border_ids.include?(tile.top)
        else
          tile.flip unless tile.top == image[-2][image.last.size].bottom
        end
        image.last << tile
        last = tile
      end
      break unless remaining_tiles.any?
      tile = remove_tile(remaining_tiles) { |tile| tile.border_ids.include?(image.last.first.bottom) }
      until tile.top == image.last.first.bottom
        tile.rotate
      end
      tile.flip_h unless outer_border_ids.include?(tile.left)
      image << [tile]
      last = tile
    end
    final = image.map { |row| row.map(&:borderless) }.map { |row| row.transpose.map(&:flatten) }.flatten(1)
    puts final.map { |row| row.map { |v| v ? '#' : '.' }.join }.join("\n")
    2.times do
      final = final.reverse
      4.times do
        final = final.transpose.map(&:reverse)
        mark_monsters(final)
      end
    end
    final.flatten.count(true)
  end
end

Day20.run if __FILE__ == $0

#!/usr/bin/env ruby

require_relative 'day'
require_relative 'dijkstra'

class NilClass
  def [](_)
    nil
  end
end

class Day20 < Day
  ALPHA = /[A-Z]/
  def part_1
    graph = Graph.new
    warps = Hash.new { |h, k| h[k] = Array.new }
    maze = input.each_line.map { |l| l.chomp.each_char.to_a }
    maze.each_with_index do |chars, r|
      chars.each_with_index do |char, c|
        if char == '.' && maze[r][c+1] == '.'
          graph.add_edge([r,c], [r,c+1])
        end
        if char == '.' && maze[r+1][c] == '.'
          graph.add_edge([r,c], [r+1,c])
        end
        if ALPHA =~ char && ALPHA =~ maze[r][c+1]
          wr, wc = [[r,c-1], [r,c+2]].find { |r,c| maze[r][c] == '.' }
          warps[[char, maze[r][c+1]].join] << [wr,wc]
        end
        if ALPHA =~ char && ALPHA =~ maze[r+1][c]
          wr, wc = [[r-1,c], [r+2,c]].find { |r,c| maze[r][c] == '.' }
          warps[[char, maze[r+1][c]].join] << [wr,wc]
        end
      end
    end
    warps.values.select { |v| v.count == 2 }.each do |v|
      graph.add_edge(v.first, v.last)
    end
    # graph.dijkstra(warps['AA'].first)
    # graph.distance[warps['ZZ'].first]
    nil
  end

  def part_2_bad
    graph = Graph.new
    warps = Hash.new { |h, k| h[k] = Array.new }
    maze = input.each_line.map { |l| l.chomp.each_char.to_a }
    maze.each_with_index do |chars, r|
      chars.each_with_index do |char, c|
        (0..20).each do |layer|
          if char == '.' && maze[r][c+1] == '.'
            graph.add_edge([r,c, layer], [r,c+1, layer])
          end
          if char == '.' && maze[r+1][c] == '.'
            graph.add_edge([r,c, layer], [r+1,c, layer])
          end
        end
        if ALPHA =~ char && ALPHA =~ maze[r][c+1]
          wr, wc = [[r,c-1], [r,c+2]].find { |r,c| maze[r][c] == '.' }
          warps[[char, maze[r][c+1]].join] << [wr,wc]
        end
        if ALPHA =~ char && ALPHA =~ maze[r+1][c]
          wr, wc = [[r-1,c], [r+2,c]].find { |r,c| maze[r][c] == '.' }
          warps[[char, maze[r+1][c]].join] << [wr,wc]
        end
      end
    end
    warps.select { |_,v| v.count == 2 }.each do |k,v|
      (r1,c1),(r2,c2) = v
      if r1 == 2 || c1 == 2 || r1 == maze.count-3 || c1 == maze.first.count-3
        r1, c1, r2, c2 = r2, c2, r1, c1
      end
      puts [k,[r1,c1,0], [r2,c2,1]].inspect
      (0..20).each do |l|
        graph.add_edge([r1,c1,l], [r2,c2,l+1])
      end
    end
    graph.dijkstra([warps['AA'].first,0].flatten)
    graph.distance[[warps['ZZ'].first,0].flatten]
  end

  def part_2
    graph = Graph.new
    warps = Hash.new { |h, k| k }
    labels = []
    maze = input.each_line.map { |l| l.chomp.each_char.to_a }
    maze.each_with_index do |chars, r|
      chars.each_with_index do |char, c|
        if ALPHA =~ char && ALPHA =~ maze[r][c+1]
          wr, wc = [[r,c-1], [r,c+2]].find { |r,c| maze[r][c] == '.' }
          outin = (wr == 2 || wc == 2 || wr == maze.count-3 || wc == maze.first.count-3) ? 'O' : 'I'
          label = [outin, char, maze[r][c+1]].join
          warps[[wr,wc]] = label
          labels << label
        end
        if ALPHA =~ char && ALPHA =~ maze[r+1][c]
          wr, wc = [[r-1,c], [r+2,c]].find { |r,c| maze[r][c] == '.' }
          outin = (wr == 2 || wc == 2 || wr == maze.count-3 || wc == maze.first.count-3) ? 'O' : 'I'
          label = [outin, char, maze[r+1][c]].join
          warps[[wr,wc]] = label
          labels << label
        end
      end
    end
    maze.each_with_index do |chars, r|
      chars.each_with_index do |char, c|
        if char == '.' && maze[r][c+1] == '.'
          graph.add_edge(warps[[r,c]], warps[[r,c+1]])
        end
        if char == '.' && maze[r+1][c] == '.'
          graph.add_edge(warps[[r,c]], warps[[r+1,c]])
        end
      end
    end

    graph2 = Graph.new

    labels.each do |label|
      graph.dijkstra(label)
      graph.distance.select do |k, v|
        if k.is_a?(String) && v < 1000000000000000 && k < label
          (0..50).each do |layer|
            graph2.add_edge([k, layer], [label, layer], v)
          end
        end
      end
    end
    (labels.map { |l| l[1..2] }.uniq - ['AA', 'ZZ']).each do |l|
      (0..50).each do |layer|
        graph2.add_edge(['I'+l,layer], ['O'+l,layer+1])
      end
    end
    graph2.dijkstra(['OAA', 0])
    graph2.distance[['OZZ',0]]
  end


  #def input
  #  '             Z L X W       C                 
  #           Z P Q B       K                 
  ############.#.#.#.#######.###############  
  ##...#.......#.#.......#.#.......#.#.#...#  
  ####.#.#.#.#.#.#.#.###.#.#.#######.#.#.###  
  ##.#...#.#.#...#.#.#...#...#...#.#.......#  
  ##.###.#######.###.###.#.###.###.#.#######  
  ##...#.......#.#...#...#.............#...#  
  ##.#########.#######.#.#######.#######.###  
  ##...#.#    F       R I       Z    #.#.#.#  
  ##.###.#    D       E C       H    #.#.#.#  
  ##.#...#                           #...#.#  
  ##.###.#                           #.###.#  
  ##.#....OA                       WB..#.#..ZH
  ##.###.#                           #.#.#.#  
#CJ......#                           #.....#  
  ########                           #######  
  ##.#....CK                         #......IC
  ##.###.#                           #.###.#  
  ##.....#                           #...#.#  
  ####.###                           #.#.#.#  
#XF....#.#                         RF..#.#.#  
  ######.#                           #######  
  ##......CJ                       NM..#...#  
  ####.#.#                           #.###.#  
#RE....#.#                           #......RF
  ####.###        X   X       L      #.#.#.#  
  ##.....#        F   Q       P      #.#.#.#  
  ####.###########.###.#######.#########.###  
  ##.....#...#.....#.......#...#.....#.#...#  
  ######.#.###.#######.#######.###.###.#.#.#  
  ##.......#.......#.#.#.#.#...#...#...#.#.#  
  ######.###.#####.#.#.#.#.###.###.#.###.###  
  ##.......#.....#.#...#...............#...#  
  ##############.#.#.###.###################  
  #             A O F   N                     
  #             A A D   M                     '
  #end
end

Day20.run if __FILE__ == $0

# https://gist.github.com/jithinabraham/63d34bdf1c94a01d6e91864d4dc583f4
#
class Graph
  attr_reader :graph, :nodes, :previous, :distance #getter methods
  INFINITY = 1 << 64

  def initialize
    # the graph // {node => { edge1 => weight, edge2 => weight}, node2 => ...
    @graph = Hash.new { |hash, key| hash[key] = {} }
    @nodes = Array.new
  end

# connect each node with target and weight
  def connect_graph(source, target, weight = 1)
    if (!graph.has_key?(source))
      graph[source] = {target => weight}
    else
      graph[source][target] = weight
    end
    if (!nodes.include?(source))
      nodes << source
    end
    if (!nodes.include?(target))
      nodes << target
    end
  end

# connect each node bidirectional
  def add_edge(source, target, weight = 1)
    connect_graph(source, target, weight) #directional graph
    connect_graph(target, source, weight) #non directed graph (inserts the other edge too)
  end


# based of wikipedia's pseudocode: http://en.wikipedia.org/wiki/Dijkstra's_algorithm


  def dijkstra(source)
    @distance={}
    @previous={}
    nodes.each do |node|#initialization
      @distance[node] = INFINITY #Unknown distance from source to vertex
      @previous[node] = -1 #Previous node in optimal path from source
    end

    @distance[source] = 0 #Distance from source to source

    unvisited_node = nodes.compact #All nodes initially in Q (unvisited nodes)

    while (unvisited_node.size > 0)
      u = nil;

      unvisited_node.each do |min|
        if (not u) or (@distance[min] and @distance[min] < @distance[u])
          u = min
        end
      end

      if (@distance[u] == INFINITY)
        break
      end

      unvisited_node = unvisited_node - [u]

      graph[u].keys.each do |vertex|
        alt = @distance[u] + graph[u][vertex]

        if (alt < @distance[vertex])
          @distance[vertex] = alt
          @previous[vertex] = u  #A shorter path to v has been found
        end

      end

    end

  end


# To find the full shortest route to a node

  def find_path(dest)
    @path ||= []
    if @previous[dest] != -1
      find_path @previous[dest]
    end
    @path << dest
  end


# Gets all shortests paths using dijkstra

  def shortest_paths(source)
    @graph_paths=[]
    @source = source
    dijkstra source
    nodes.each do |dest|
      @path=[]

      find_path dest

      actual_distance=if @distance[dest] != INFINITY
                        @distance[dest]
                      else
                        "no path"
                      end
      @graph_paths<< "Target(#{dest})  #{@path.join("-->")} : #{actual_distance}"
    end
    @graph_paths
  end

  # print result

  def print_result
    @graph_paths.each do |graph|
      puts graph
    end
  end

end

if __FILE__ == $0
#sample input as per http://en.wikipedia.org/wiki/Dijkstra's_algorithm
  gr = Graph.new
  gr.add_edge("a", "c", 7)
  gr.add_edge("a", "e", 14)
  gr.add_edge("a", "f", 9)
  gr.add_edge("c", "d", 15)
  gr.add_edge("c", "f", 10)
  gr.add_edge("d", "f", 11)
  gr.add_edge("d", "b", 6)
  gr.add_edge("f", "e", 2)
  gr.add_edge("e", "b", 9)
  gr.shortest_paths("a")
  gr.print_result

end

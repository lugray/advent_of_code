class Program
  attr_reader :name, :weight
  attr_accessor :children
  attr_accessor :parent

  def initialize(name, weight)
    @name = name
    @weight = weight.to_i
    @children = []
  end

  def to_s
    "#{name} (#{weight})"
  end

  def full_weight
    @full_weight ||= weight + children.map(&:full_weight).inject(0, &:+)
  end
end

input = File.read(File.dirname(__FILE__) + '/input').chomp

programs = {}

input.split("\n").each do |line|
  name, weight = line.match(/(\w+) \((\d+)\)/).captures
  programs[name] = Program.new(name, weight)
end

input.split("\n").each do |line|
  next unless matches = line.match(/(\w+) \(\d+\) -> (.+)/)
  name, children = matches.captures
  programs[name].children = children.split(", ").map do |child|
    programs[child]
  end
  programs[name].children.each do |child|
    child.parent = programs[name]
  end
end

bottom = programs.values.first

loop do
  break unless bottom.parent
  bottom = bottom.parent
end

puts bottom.name

unique_sibling = bottom
loop do
  siblings = unique_sibling.children
  weights = siblings.map(&:full_weight)
  break unless unique_weight = weights.group_by(&:itself).transform_values(&:length).invert[1]
  unique_sibling = siblings[weights.index(unique_weight)]
end
siblings = unique_sibling.parent.children
weights = siblings.map(&:full_weight).uniq
proper_weight = weights.inject(&:+) - 2 * unique_sibling.full_weight + unique_sibling.weight
puts proper_weight
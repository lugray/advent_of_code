require 'yaml'
require 'pp'

input = File.read(File.dirname(__FILE__) + '/input.txt')
sues = Hash[input.split("\n").map do |line|
  sue, stuff = line.split(': ', 2)
  [sue, YAML.load("{#{stuff}}")]
end]

detected = {
  "children" => 3,
  "cats" => 7,
  "samoyeds" => 2,
  "pomeranians" => 3,
  "akitas" => 0,
  "vizslas" => 0,
  "goldfish" => 5,
  "trees" => 3,
  "cars" => 2,
  "perfumes" => 1,
}

sues.each do |sue, stuff|
  if detected.values_at(*stuff.keys) == stuff.values_at(*stuff.keys)
    puts sue
  end
end

sues.each do |sue, stuff|
  matches = stuff.map do |type, amount|
    case type
    when "cats", "trees"
      amount > detected[type]
    when "pomeranians", "goldfish"
      amount < detected[type]
    else
      amount == detected[type]
    end
  end
  if matches.all?
    puts sue
  end
end


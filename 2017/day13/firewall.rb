require 'yaml'
scanners = YAML.load_file(File.dirname(__FILE__) + '/input')

def caught?(departure, depth, range)
  modulo = range * 2 - 2
  (departure + depth) % modulo == 0
end

caught_at = scanners.select { |depth, range| caught?(0, depth, range) }

severity = caught_at.map { |depth, range| depth * range }.inject(&:+)

puts severity

departure = 1
loop do
  break if scanners.none? { |depth, range| caught?(departure, depth, range) }
  departure += 1
end

puts departure
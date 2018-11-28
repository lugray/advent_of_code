input = File.read(File.dirname(__FILE__) + '/input.txt')

jugs = input.split("\n").map(&:to_i)

# def combos(jugs, target)
#   return enum_for(:combos, jugs, target) unless block_given?
#   return if jugs.empty?
#   if target == 0
#     yield [0] * jugs.length
#     return
#   end
#   max_first = target / jugs.first
#   other_jugs = jugs.dup
#   this_jug = other_jugs.shift
#   (0..max_first).each do |n|
#     combos(other_jugs, target- n * this_jug).each do |sub|
#       yield [n] + sub
#     end
#   end
# end

class Array
  def all_combinations
    return enum_for(:all_combinations) unless block_given?
    (1..length).each do |n|
      combination(n) do |combo|
        yield combo
      end
    end
  end
end

def combos(jugs, target)
  jugs.all_combinations.select do |combo|
    combo.inject(&:+) == target
  end
end

ways = combos(jugs, 150)

puts ways.count

min_jugs = ways.map(&:length).min

ways_with_min = ways.select do |way|
  way.length == min_jugs
end

puts ways_with_min.count


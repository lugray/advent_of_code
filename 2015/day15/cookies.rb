require 'matrix'
require 'byebug'

PARSER = /\w+: capacity (-?\d+), durability (-?\d+), flavor (-?\d+), texture (-?\d+), calories (-?\d+)/

input = File.read(File.dirname(__FILE__) + '/input.txt').chomp

# input = 'Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
# Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3
# '

ingredients = input.split("\n").map do |line|
  Vector[*line.match(PARSER).captures.map(&:to_i)]
end

def splits(total, groups)
  return enum_for(:splits, total, groups) unless block_given?
  if groups == 1
    yield [total]
    return
  end
  (0..total).each do |i|
    splits(total - i, groups - 1).each do |sub|
      yield [i] + sub
    end
  end
end

def best_score(ingredients, calories: nil)
  best = 0
  splits(100, ingredients.size).each do |split|
    sum = ingredients.zip(split).map do |ingredient, teaspoons|
      teaspoons * ingredient
    end.inject(&:+)
    sum = sum.map { |el| [el, 0].max }.to_a
    cals = sum.pop
    next if calories && calories != cals
    score = sum.inject(&:*)
    best = [best, score].max
  end
  best
end

puts best_score(ingredients)
puts best_score(ingredients, calories: 500)

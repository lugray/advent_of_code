#!/usr/bin/env ruby

require_relative 'day'

class Day21 < Day
  def input
    return super
    <<~INPUT
      mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
      trh fvjkl sbzzf mxmxvkd (contains dairy)
      sqjhc fvjkl (contains soy)
      sqjhc mxmxvkd sbzzf (contains fish)
    INPUT
  end

  def initialize
    @dictionary = {}
    @all_ingredients = []
    input.each_line(chomp: true) do |l|
      ingredients, allergens = l.split(' (contains ')
      ingredients = ingredients.split(' ')
      allergens = allergens[...-1].split(', ')
      @all_ingredients += ingredients
      allergens.each do |allergen|
        if @dictionary[allergen]
          @dictionary[allergen] = @dictionary[allergen] & ingredients
        else
          @dictionary[allergen] = ingredients
        end
      end
    end
  end

  def part_1
    potential_allergens = @dictionary.values.flatten.uniq
    @all_ingredients.reject { |ingredient| potential_allergens.include?(ingredient) }.count
  end

  def part_2
    changed = true
    while changed do
      changed = false
      solos = @dictionary.values.select { |ingredients| ingredients.size == 1}.flatten
      @dictionary.keys.each do |allergen|
        if s = @dictionary[allergen].size > 1
          @dictionary[allergen] = @dictionary[allergen] - solos
          changed = true unless @dictionary[allergen].size == s
        end
      end
    end
    @dictionary.sort_by { |k, v| k }.map(&:last).flatten.join(',')
  end
end

Day21.run if __FILE__ == $0

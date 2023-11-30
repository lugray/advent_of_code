#!/usr/bin/env ruby

require_relative 'day'


class Day24 < Day
  NoChange = Class.new(StandardError)
  class Group
    attr_reader :units, :hp, :weaknesses, :immunities, :attack_type, :initiative
    attr_accessor :target, :attack_damage

    def initialize(units, hp, weaknesses, immunities, attack_damage, attack_type, initiative)
      @units = units
      @hp = hp
      @weaknesses = weaknesses
      @immunities = immunities
      @attack_damage = attack_damage
      @attack_type = attack_type
      @initiative = initiative
    end

    def multiplier(group)
      return 1 unless group
      if group.immunities.include?(@attack_type)
        0
      elsif group.weaknesses.include?(@attack_type)
        2
      else
        1
      end
    end

    def effective_power(group = nil)
      @units * @attack_damage * multiplier(group)
    end

    def selection_order
      [effective_power, initiative]
    end

    def remove(units)
      @units -= units
      @units = 0 if @units < 0
    end
  end

  GROUP = /\A(?<units>\d+) units each with (?<hp>\d+) hit points(?: \((?<weakimmune>.*)\))? with an attack that does (?<attack_damage>\d+) (?<attack_type>\w+) damage at initiative (?<initiative>\d+)\Z/

  def initialize
    @armies = input.split("\n\n").map do |army|
      army.each_line(chomp: true).drop(1).map do |line|
        match = GROUP.match(line)
        weaknesses = []
        immunities = []
        (match[:weakimmune] || "").split('; ').each do |weakimmune|
          if weakimmune.start_with?('weak to ')
            weaknesses = weakimmune.delete_prefix('weak to ').split(', ')
          elsif weakimmune.start_with?('immune to ')
            immunities = weakimmune.delete_prefix('immune to ').split(', ')
          end
        end
        Group.new(match[:units].to_i, match[:hp].to_i, weaknesses, immunities, match[:attack_damage].to_i, match[:attack_type], match[:initiative].to_i)
      end
    end
  end

  def round
    @armies.each_with_index do |army, i|
      targets = @armies[1 - i].dup
      army.sort_by!(&:selection_order).reverse_each do |group|
        group.target = nil
        target = targets.max_by do |target|
          damage = group.effective_power(target)
          [damage, target.effective_power, target.initiative]
        end
        next unless target
        next if group.effective_power(target) == 0
        targets.delete(target)
        group.target = target
      end
    end
    attackers = @armies.flatten.sort_by(&:initiative)
    changed = false
    attackers.reverse_each do |group|
      next unless group.target
      units = group.effective_power(group.target) / group.target.hp
      changed = true if units > 0
      group.target.remove(units)
    end
    raise NoChange unless changed
    @armies.each do |army|
      army.reject! { |group| group.units == 0 }
    end
  end

  def part_1
    until @armies.any?(&:empty?)
      round
    end
    @armies.flatten.sum(&:units)
  end

  def boost_successful?(boost)
    initialize
    @armies[0].each { |group| group.attack_damage += boost }
    until @armies.any?(&:empty?)
      round
    end
    @armies[1].empty?
  rescue NoChange
    false
  end

  def part_2
    boost = 0
    boost += 1 until boost_successful?(boost)
    @armies[0].flatten.sum(&:units)
  end
end

Day24.run if __FILE__ == $0

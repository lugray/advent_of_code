#!/usr/bin/env ruby

require_relative 'day'

class Day22 < Day
  class Effect
    attr_reader :timer

    def initialize(timer, &block)
      @timer = timer
      @apply = block
    end

    def active?
      @timer > 0
    end

    def apply(game)
      raise 'expired' unless active?
      @apply.call(game)
      @timer -= 1
    end
  end

  class Shield < Effect
    def initialize
      super(6, &:apply_shield)
    end
  end

  class Poison < Effect
    def initialize
      super(6, &:apply_poison)
    end
  end

  class Recharge < Effect
    def initialize
      super(5, &:apply_recharge)
    end
  end

  class GameState
    attr_reader :spent_mana

    def initialize(boss_hp, boss_damage, player_hp = 50, player_mana = 500, effects = [], spent_mana = 0, moves = [], hard_mode = false)
      @boss_hp = boss_hp
      @boss_damage = boss_damage
      @player_hp = player_hp
      @player_mana = player_mana
      @effects = effects
      @spent_mana = spent_mana
      @moves = moves
      @armor = 0
      @hard_mode = hard_mode
    end

    def hard_mode
      GameState.new(@boss_hp, @boss_damage, @player_hp, @player_mana, @effects.map(&:dup), @spent_mana, @moves.dup, true)
    end

    def to_s
      <<~STATE
        Player HP: #{@player_hp}
        Player Mana: #{@player_mana}
        Boss HP: #{@boss_hp}
        Spent Mana: #{@spent_mana}
        Moves: #{@moves.join(':')}
        Effects:
        #{@effects.map { |effect| " - #{effect.class.name.split('::').last}: #{effect.timer}" }.join("\n")}
      STATE
    end

    def apply_shield
      @armor = 7
    end

    def apply_poison
      @boss_hp -= 3
    end

    def apply_recharge
      @player_mana += 101
    end

    def lost?
      @player_hp <= 0 || @player_mana < 0 || @effects.map(&:class).uniq.length < @effects.length
    end

    def won?
      @boss_hp <= 0
    end

    def over?
      lost? || won?
    end

    def magic_missiles
      new_state(boss_delta: -4, mana_delta: -53, move: 'm')
    end

    def drain
      new_state(boss_delta: -2, player_delta: +2, mana_delta: -73, move: 'd')
    end

    def shield
      new_state(mana_delta: -113, effect: Shield.new, move: 's')
    end

    def poison
      new_state(mana_delta: -173, effect: Poison.new, move: 'p')
    end

    def recharge
      new_state(mana_delta: -229, effect: Recharge.new, move: 'r')
    end

    def next_states
      return [self] if won?
      [
        magic_missiles,
        drain,
        shield,
        poison,
        recharge
      ].reject(&:lost?)
    end

    def new_state(boss_delta: 0, player_delta: 0, mana_delta: 0, effect: nil, move:)
      new_effects = @effects.map(&:dup)
      new_effects << effect if effect
      GameState.new(@boss_hp + boss_delta, @boss_damage, @player_hp + player_delta, @player_mana + mana_delta, new_effects, @spent_mana - mana_delta, @moves.dup << move, @hard_mode).boss_turn
    end

    def apply_effects
      @effects.each { |effect| effect.apply(self) }
      @effects.select!(&:active?)
    end

    def boss_damage
      [@boss_damage - @armor, 1].max
    end

    def boss_turn
      return self if over?
      apply_effects
      return self if over?
      @player_hp -= boss_damage
      return self if over?
      apply_effects
      @player_hp -= 1 if @hard_mode
      self
    end
  end

  def initialize
    boss_hp, boss_damage = input.each_line.map { |l| l.split(': ').last.to_i }
    @game = GameState.new(boss_hp, boss_damage)
  end

  def chepeast_win(game)
    states = [game]
    loop do
      best_winner = states.select(&:won?).min_by(&:spent_mana)
      if best_winner
        states.reject! { |s| s.spent_mana > best_winner.spent_mana }
      end
      return states.first if best_winner && states.all? { |s| s.spent_mana == best_winner.spent_mana }
      states = states.flat_map(&:next_states)
    end
  end

  def part_1
    chepeast_win(@game).spent_mana
  end

  def part_2
    chepeast_win(@game.hard_mode).spent_mana
  end
end

Day22.run if __FILE__ == $0

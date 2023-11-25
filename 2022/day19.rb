#!/usr/bin/env ruby

require_relative 'day'

class Day19 < Day
  PATTERN = /Blueprint (?<blueprint>\d+): Each ore robot costs (?<orebot_ore>\d+) ore. Each clay robot costs (?<claybot_ore>\d+) ore. Each obsidian robot costs (?<obsidianbot_ore>\d+) ore and (?<obsidianbot_clay>\d+) clay. Each geode robot costs (?<geodebot_ore>\d+) ore and (?<geodebot_obsidian>\d+) obsidian./

  class Blueprint
    attr_reader :blueprint, :orebot_ore, :claybot_ore, :obsidianbot_ore, :obsidianbot_clay, :geodebot_ore, :geodebot_obsidian
    def initialize(blueprint:, orebot_ore:, claybot_ore:, obsidianbot_ore:, obsidianbot_clay:, geodebot_ore:, geodebot_obsidian:)
      @blueprint = blueprint
      @orebot_ore = orebot_ore
      @claybot_ore = claybot_ore
      @obsidianbot_ore = obsidianbot_ore
      @obsidianbot_clay = obsidianbot_clay
      @geodebot_ore = geodebot_ore
      @geodebot_obsidian = geodebot_obsidian
    end
  end

  class State
    attr_reader :orebots, :claybots, :obsidianbots, :geodebots, :ores, :clays, :obsidians, :geodes
    def initialize(blueprint:, orebots: 1, claybots: 0, obsidianbots: 0, geodebots: 0, ores: 0, clays: 0, obsidians: 0, geodes: 0)
      @blueprint = blueprint
      @orebots = orebots
      @claybots = claybots
      @obsidianbots = obsidianbots
      @geodebots = geodebots
      @ores = ores
      @clays = clays
      @obsidians = obsidians
      @geodes = geodes
    end

    def to_h
      {
        blueprint: @blueprint,
        orebots: @orebots,
        claybots: @claybots,
        obsidianbots: @obsidianbots,
        geodebots: @geodebots,
        ores: @ores,
        clays: @clays,
        obsidians: @obsidians,
        geodes: @geodes,
      }
    end

    def can_build_geodebot?
      @ores >= @blueprint.geodebot_ore && @obsidians >= @blueprint.geodebot_obsidian
    end

    def can_build_obsidianbot?
      @ores >= @blueprint.obsidianbot_ore && @clays >= @blueprint.obsidianbot_clay && !max_obsidianbots?
    end

    def can_build_orebot?
      @ores >= @blueprint.orebot_ore && !max_orebots?
    end

    def can_build_claybot?
      @ores >= @blueprint.claybot_ore && !max_claybots?
    end

    def max_obsidianbots?
      # More than this produces more each minute than we can ever consume in a minute
      @obsidianbots >= @blueprint.geodebot_obsidian
    end

    def max_claybots?
      # More than this produces more each minute than we can ever consume in a minute
      @claybots >= @blueprint.obsidianbot_clay
    end

    def max_orebots?
      # More than this produces more each minute than we can ever consume in a minute
      @orebots >= [@blueprint.obsidianbot_ore, @blueprint.claybot_ore, @blueprint.orebot_ore, @blueprint.geodebot_ore].max
    end

    def bots_work
      to_h.tap do |h|
        h[:ores] += @orebots
        h[:clays] += @claybots
        h[:obsidians] += @obsidianbots
        h[:geodes] += @geodebots
      end
    end

    def build_geodebot
      h = bots_work
      h[:geodebots] += 1
      h[:ores] -= @blueprint.geodebot_ore
      h[:obsidians] -= @blueprint.geodebot_obsidian
      State.new(**h)
    end

    def build_obsidianbot
      h = bots_work
      h[:obsidianbots] += 1
      h[:ores] -= @blueprint.obsidianbot_ore
      h[:clays] -= @blueprint.obsidianbot_clay
      State.new(**h)
    end

    def build_orebot
      h = bots_work
      h[:orebots] += 1
      h[:ores] -= @blueprint.orebot_ore
      State.new(**h)
    end

    def build_claybot
      h = bots_work
      h[:claybots] += 1
      h[:ores] -= @blueprint.claybot_ore
      State.new(**h)
    end

    def build_nothing
      State.new(**bots_work)
    end

    def next_states
      [].tap do |states|
        states << build_geodebot if can_build_geodebot?
        states << build_obsidianbot if can_build_obsidianbot?
        states << build_claybot if can_build_claybot?
        states << build_orebot if can_build_orebot?
        states << build_nothing
      end
    end

    def optimistic_minutes_to_next_geodebot
      minutes = 0
      obsidians = @obsidians
      obsidianbots = @obsidianbots
      while obsidians < @blueprint.geodebot_obsidian
        obsidians += obsidianbots
        obsidianbots += 1
        minutes += 1
      end
      minutes
    end

    def optimistic_geodes(minutes)
      optimistic_max_production_minutes = [0, minutes - optimistic_minutes_to_next_geodebot].max
      @geodes + minutes * @geodebots + optimistic_max_production_minutes * (optimistic_max_production_minutes - 1) / 2
    end
  end

  def initialize
    @blueprints = input_lines do |line|
      line.match(PATTERN) do |m|
        h = m.named_captures.transform_keys(&:to_sym).transform_values(&:to_i)
        Blueprint.new(**h)
      end
    end
  end

  class GeodeMaximizer
    def initialize(state, max_minutes)
      @state = state
      @max_minutes = max_minutes
      @max_geodes = -1
    end

    def search(state = @state, minutes = @max_minutes)
      return if state.optimistic_geodes(minutes) <= @max_geodes
      @max_geodes = state.geodes if state.geodes > @max_geodes
      return if minutes == 0
      state.next_states.each { |next_state| search(next_state, minutes - 1) }
    end

    def max_geodes
      return @max_geodes if @max_geodes >= 0
      search
      @max_geodes
    end
  end

  def part_1
    @blueprints.sum do |blueprint|
      GeodeMaximizer.new(State.new(blueprint: blueprint), 24).max_geodes * blueprint.blueprint
    end
  end

  def part_2
    @blueprints.first(3).map do |blueprint|
      GeodeMaximizer.new(State.new(blueprint: blueprint), 32).max_geodes
    end.reduce(:*)
  end
end

Day19.run if __FILE__ == $0

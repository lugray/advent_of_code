class DiscDrop
  PARSER = /Disc #(\d+) has (\d+) positions; at time=0, it is at position (\d+)./

  def initialize(input)
    @input = input.each_line.map(&:strip).reject{ |line| line == "" }
  end

  def add_disk(mod, pos)
    @goal_mod = goal_mod | [goal_mod_from_parsed(@goal_mod.size+1, mod, pos)]
    self
  end

  def goal_mod_from_parsed(disc, mod, pos)
    [(-pos-disc).modulo(mod), mod]
  end

  def goal_mod
    @goal_mod ||= @input.map do |line|
      disc, mod, pos = *line.scan(PARSER).first.map(&:to_i)
      goal_mod_from_parsed(disc, mod, pos)
    end
  end

  def drop_time
    (1..Float::INFINITY).find do |time|
      goal_mod.all? do |params|
        goal, mod = *params
        time.modulo(mod) == goal
      end
    end
  end
end

puts DiscDrop.new(File.open(File.dirname(__FILE__) + '/input.txt').read).drop_time
puts DiscDrop.new(File.open(File.dirname(__FILE__) + '/input.txt').read).add_disk(11, 0).drop_time

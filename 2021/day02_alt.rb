#!/usr/bin/env ruby

require_relative 'day'

class Day02 < Day
  def initialize
    @movements = input.each_line.map do |l|
      a, b = l.split(' ')
      [a, b.to_i]
    end
  end

  class Sub
    def initialize
      @x = 0
      @y = 0
    end

    def forward(d)
      @x += d
    end

    def down(d)
      @y += d
    end

    def up(d)
      @y -= d
    end

    def run(instructions)
      instructions.each { |dir, d| send(dir, d) }
      self
    end

    def result
      @x * @y
    end
  end

  class AimingSub < Sub
    def initialize
      super
      @aim = 0
    end

    def forward(d)
      super
      @y += d * @aim
    end

    def down(d)
      @aim += d
    end

    def up(d)
      @aim -= d
    end
  end

  def part_1
    Sub.new.run(@movements).result
  end

  def part_2
    AimingSub.new.run(@movements).result
  end
end

Day02.run if __FILE__ == $0

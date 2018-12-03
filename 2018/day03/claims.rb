#!/usr/bin/env ruby

class Claims
  def initialize(claims)
    @claims = claims.map { |claim| Claim.new(claim) }
    @fabric = Fabric.new
    @claims.each do |claim|
      @fabric.claim(claim)
    end
  end

  def duplicate_area
    @fabric.duplicate_area
  end

  def clean_claim
    @claims.find do |claim|
      claim.squares.all? { |sq| @fabric[sq] == 1 }
    end.id
  end

  class Fabric
    def initialize
      @fabric = Hash.new(0)
    end

    def [](key)
      @fabric[key]
    end

    def claim(cl)
      cl.squares.each do |square|
        @fabric[square] += 1
      end
    end

    def duplicate_area
      @fabric.count { |_address, c| c > 1 }
    end
  end

  class Claim
    attr_reader :id
    CLAIM = /^#(?<id>\d+) @ (?<x>\d+),(?<y>\d+): (?<w>\d+)x(?<h>\d+)$/
    def initialize(str)
      matches = str.match(CLAIM)
      @id = matches[:id].to_i
      @x = matches[:x].to_i
      @y = matches[:y].to_i
      @w = matches[:w].to_i
      @h = matches[:h].to_i
    end

    def squares
      (@x...@x+@w).map do |x|
        (@y...@y+@h).map do |y|
          [x, y]
        end
      end.flatten(1)
    end
  end
end

claims = Claims.new(File.readlines('input').map(&:chomp))
puts claims.duplicate_area
puts claims.clean_claim

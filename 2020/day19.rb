#!/usr/bin/env ruby

require_relative 'day'

class Rule
  class << self
    attr_reader :set
    def parse_set(rules)
      @set = rules.each_line(chomp: true).map do |l|
        n, body = l.split(': ')
        [n.to_i, create(body)]
      end.to_h
    end

    def create(body)
      case body
      when /"\w"/
        FinalRule.new(body[1])
      else
        new(body)
      end
    end
  end

  def initialize(body)
    @subrules = body.split('|').map do |part|
      part.split(' ').map(&:to_i)
    end
  end

  def to_regex_str
    r = @subrules.map do |alternation|
      alternation.map do |rule|
        Rule.set[rule].to_regex_str
      end.join
    end.join('|')
    "(?:#{r})"
  end

  def to_regex
    /^#{to_regex_str}$/
  end
end

class FinalRule < Rule
  def initialize(letter)
    @letter = letter
  end

  def to_regex_str
    @letter
  end
end

class Day19 < Day
  def initialize
    rules, messages = input.split("\n\n")
    Rule.parse_set(rules)
    @messages = messages.each_line(chomp: true).to_a
  end

  def part_1
    rule_0 = Rule.set[0].to_regex
    @messages.count { |message| rule_0.match?(message) }
  end

  def part_2
    r8 = Rule.set[8]
    def r8.to_regex_str
      Rule.set[42].to_regex_str + '+'
    end
    r11 = Rule.set[11]
    def r11.to_regex_str
      "(?'r11'#{Rule.set[42].to_regex_str}\\g<r11>?#{Rule.set[31].to_regex_str})"
    end
    rule_0 = Rule.set[0].to_regex
    return @messages.count { |message| rule_0.match?(message) }
  end
end

Day19.run if __FILE__ == $0

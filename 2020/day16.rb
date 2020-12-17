#!/usr/bin/env ruby

require_relative 'day'

class Rule
  attr_reader :field

  def initialize(line)
    @field, ranges = line.split(': ')
    @ranges = ranges.split(' or ').map { |r| Range.new(*r.split('-').map(&:to_i)) }
  end

  def valid?(field)
    @ranges.any? { |r| r.include?(field) }
  end
end

class Parser
  attr_reader :rules, :nearby_tickets, :your_ticket

  def initialize(input)
    @lines = input.each_line.map(&:chomp)
    @rules = []
    @nearby_tickets = []
  end

  def self.parse(input)
    p = new(input)
    p.parse
    [p.rules, p.nearby_tickets, p.your_ticket]
  end

  def parse
    until (line = @lines.shift).empty? do
      rule = Rule.new(line)
      @rules << rule
    end
    raise unless @lines.shift == 'your ticket:'
    @your_ticket = parse_ticket_line(@lines.shift)
    raise unless @lines.shift.empty?
    raise unless @lines.shift == 'nearby tickets:'
    while line = @lines.shift do
      @nearby_tickets << parse_ticket_line(line)
    end
  end

  def parse_ticket_line(line)
    line.split(',').map(&:to_i)
  end
end

class Day16 < Day
  def initialize
    @rules, @nearby_tickets, @your_ticket = Parser.parse(input)
  end

  def part_1
    error_rate = 0
    @nearby_tickets.each do |ticket|
      ticket.each do |field|
        if @rules.none? { |rule| rule.valid?(field) }
          error_rate += field
        end
      end
    end

    error_rate
  end

  def part_2
    @nearby_tickets.reject! do |ticket|
      ticket.any? do |field|
        @rules.none? { |rule| rule.valid?(field) }
      end
    end
    fields = Array.new(@your_ticket.size) { @rules.dup }
    (@nearby_tickets + [@your_ticket]).each do |ticket|
      ticket.zip(fields).each do |field, rules|
        rules.select! do |rule|
          rule.valid?(field)
        end
      end
    end
    changed = true
    while changed do
      changed = false
      fields.each do |rules|
        if rules.one?
          fields.each do |rs|
            next if rs == rules
            rs.reject! do |r|
              if r == rules.first
                changed = true
              end
            end
          end
        end
      end
    end
    raise "Not done" unless fields.all?(&:one?)
    fields = fields.map(&:first)
    fields.zip(@your_ticket).select { |field, tf| field.field.start_with?('departure') }.map(&:last).inject(&:*)
  end
end

Day16.run if __FILE__ == $0

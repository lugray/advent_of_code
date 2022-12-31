#!/usr/bin/env ruby

require_relative 'day'
require 'set'

class Day16 < Day
  class Valve
    attr_reader :name
    attr_accessor :flow, :connections

    class << self
      def [](name)
        @valves ||= {}
        @valves[name] ||= new(name)
      end

      def each_useless(&block)
        return enum_for(:each_useless) unless block_given?
        loop do
          useless = @valves.values.find { |valve| valve.flow == 0 && valve.name != 'AA' }
          break if useless.nil?
          yield useless
        end
      end

      def each(&block)
        return enum_for(:each) unless block_given?
        @valves.values.each(&block)
      end

      def delete!(name)
        @valves.delete(name)
        @valves.values.each do |valve|
          valve.connections.reject! { |connection| connection.valve.name == name }
        end
      end
    end

    def ==(other)
      name == other.name
    end

    def initialize(name)
      @name = name
      @flow = 0
      @connections = []
    end

    def delete!
      Valve.delete!(name)
    end

    def connect(other, distance)
      return if other == self
      c = @connections.find { |connection| connection.valve == other }
      if c
        c.distance = distance if distance < c.distance
      else
        @connections << Connection.new(other, distance)
      end
    end

    def connect_connections
      connections.combination(2).each do |connection1, connection2|
        connection2.valve.connect(connection1.valve, connection1.distance + connection2.distance)
        connection1.valve.connect(connection2.valve, connection1.distance + connection2.distance)
      end
    end
  end

  class Connection
    attr_accessor :distance
    attr_reader :valve

    def initialize(valve, distance)
      @valve = valve
      @distance = distance
    end
  end

  def initialize
    input.each_line(chomp: true) do |line, h|
      key, flow, *connections = line.scan(/[A-Z]{2}|\d+/).map(&method(:to_i_if_i))
      Valve[key].flow = flow
      connections.each do |connection|
        Valve[key].connections << Connection.new(Valve[connection], 1)
      end
    end
    Valve.each_useless do |valve|
      next unless valve.flow == 0
      next if valve.name == 'AA'
      valve.connect_connections
      valve.delete!
    end
    Valve.each.count.times do
      Valve.each(&:connect_connections)
    end
    Valve.each do |valve|
      valve.connections.reject! { |connection| connection.valve.flow == 0 } # remove connections to useless AA valve
    end
  end

  def paths(time_remaining, head = [Valve['AA']], &block)
    return enum_for(:paths, time_remaining, head) unless block_given?
    yield head
    time_remaining -= 1
    candidates = head.last.connections.reject { |connection| head.include?(connection.valve) || connection.distance >= time_remaining }
    return if candidates.empty?
    candidates.each do |connection|
      paths(time_remaining - connection.distance, head + [connection.valve], &block)
    end
  end

  def dist(valve1, valve2)
    return 0 unless valve1 && valve2
    @dist ||= {}
    @dist[[valve1, valve2]] ||= valve1.connections.find { |connection| connection.valve == valve2 }.distance
  end

  def total_flow(path, time_remaining)
    return 0 if path.empty?
    if path.first.flow == 0
      return total_flow(path[1..-1], time_remaining - dist(path.first, path[1]))
    end
    time_remaining -= 1
    return path.first.flow * time_remaining + total_flow(path[1..-1], time_remaining - dist(path.first, path[1]))
  end

  def part_1
    paths(30).lazy.map { |path| total_flow(path, 30) }.max
  end

  def part_2
    sets = paths(26).each_with_object({}) do |path, sets|
      flow = total_flow(path, 26)
      valve_set = Set.new(path[1..].map(&:name))
      sets[valve_set] = [sets[valve_set] || flow, flow].max
    end
    sets.map do |s1, flow1|
      sets.map do |s2, flow2|
        next 0 unless (s1 & s2).empty?
        flow1 + flow2
      end.max
    end.max
  end
end

Day16.run if __FILE__ == $0

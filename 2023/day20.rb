#!/usr/bin/env ruby

require_relative 'day'

LOW = 0
HIGH = 1

class Module
  COUNTS = Hash.new(0)
  QUEUE = []

  class << self
    def [](name)
      @modules[name] || @modules[name] = Broadcaster.new(name, [])
    end
    def []=(name, mod)
      @modules ||= {}
      @modules[name] = mod
    end
    def queue_pulse(from, to, hilo)
      QUEUE << [from, to, hilo]
    end
    def process_queue(verbose: false)
      while (from, to, hilo = QUEUE.shift)
        COUNTS[hilo] += 1
        puts "#{from.name} -#{hilo == HIGH ? 'HIGH' : 'LOW'}-> #{to.name}" if verbose
        to.pulse(from, hilo)
      end
    end
    def connect!
      @modules.values.each(&:connect!)
    end
    def reset!
      @modules.values.each(&:reset!)
      COUNTS.clear
      QUEUE.clear
    end
  end

  attr_reader :name, :inputs
  def initialize(name, outputs)
    @name = name
    @outputs = outputs
    @inputs = []
    reset!
  end

  def connect!
    @outputs.each do |output|
      Module[output].inputs << self
    end
  end
end

class Broadcaster < Module
  def pulse(from, hilo)
    @outputs.each do |output|
      Module.queue_pulse(self, Module[output], hilo)
    end
  end

  def reset!
  end
end

class Conjunction < Module
  def reset!
    @received = {}
  end

  def pulse(from, hilo)
    @received[from] = hilo
    all = @received.size == @inputs.size && @received.values.all?(HIGH)
    @outputs.each do |output|
      Module.queue_pulse(self, Module[output], all ? LOW : HIGH)
    end
  end
end

class FlipFlop < Module
  def reset!
    @state = false
  end

  def pulse(_, hilo)
    return if hilo == HIGH
    @state = !@state
    @outputs.each do |output|
      Module.queue_pulse(self, Module[output], @state ? HIGH : LOW)
    end
  end
end

class Day20 < Day
  def initialize
    input_lines do |line|
      name, outputs = line.split(' -> ')
      type = case name[0]
      when '%'
        name = name[1..-1]
        FlipFlop
      when '&'
        name = name[1..-1]
        Conjunction
      else
        Broadcaster
      end
      Module[name] = type.new(name, outputs.split(', '))
    end
    @button = Broadcaster.new('button', ['broadcaster'])
    Module.connect!
  end

  def part_1
    1000.times do
      @button.pulse('', LOW)
      Module.process_queue
    end
    Module::COUNTS[LOW] * Module::COUNTS[HIGH]
  end

  def part_2
    Module.reset!
    $done = false
    rx = Module['rx']
    def rx.pulse(_, hilo)
      if hilo == LOW
        $done = true
      end
    end
    count = 0
    until $done
      count += 1
      @button.pulse('', LOW)
      Module.process_queue
    end
    count
  end
end

Day20.run if __FILE__ == $0

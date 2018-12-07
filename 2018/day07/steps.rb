#!/usr/bin/env ruby
# coding: utf-8

class Instructions
  def initialize(input)
    @steps = {}
    input.lines.each do |line|
      md = /Step (?<first>.) must be finished before step (?<second>.) can begin./.match(line)
      first = add_step(md[:first])
      second = add_step(md[:second])
      second.add_parent(first)
    end
  end

  def each
    return enum_for(&:each) unless block_given?
    until @steps.values.all?(&:done?) do
      step = @steps.values.select(&:available?).min_by(&:id)
      yield step
      step.done
    end
    @steps.each_value(&:reset)
  end

  # 🙈 UGLY.  Don't emulate this.
  def duration(parallelization, time_delta)
    total_time = 0
    workers = Array.new(parallelization) { Worker.new(time_delta) }
    until @steps.values.all?(&:done?) do
      stp = @steps.values.select(&:available?).min_by(&:id)
      worker = workers.find { |w| w.available? }
      until (stp && worker) do
        time = workers.map(&:remaining_time).min
        workers.each { |w| w.work_for(time) }
        total_time += time
        break if @steps.values.all?(&:done?)
        stp = @steps.values.select(&:available?).min_by(&:id)
        worker = workers.find { |w| w.available? }
      end
      break if @steps.values.all?(&:done?)
      worker.assign(stp)
    end
    @steps.each_value(&:reset)
    total_time
  end

  def steps
    @steps.values
  end

  private

  def add_step(id)
    @steps[id] ||= Step.new(id)
  end

  class Worker
    def initialize(time_delta)
      @time_delta = time_delta
      @step = nil
      @progress = 0
    end

    def work_for(time)
      return unless @step
      @progress += time
      if @progress >= @step.duration + @time_delta
        @step.done
        @step = nil
        @progress = 0
      end
    end

    def remaining_time
      return Float::INFINITY if available?
      @step.duration + @time_delta - @progress
    end

    def available?
      !@step
    end

    def assign(step)
      raise "Already busy" if @step
      step.claim
      @step = step
    end
  end

  class Step
    TIME_DELTA = 1 - 'A'.ord

    attr_reader :id

    def initialize(id)
      @id = id
      @done = false
      @claimed = false
    end

    def duration
      id.ord + TIME_DELTA
    end

    def done?
      @done
    end

    def done
      @done = true
    end

    def claimed?
      @claimed
    end

    def claim
      @claimed = true
    end

    def reset
      @done = false
      @claimed = false
    end

    def available?
      !done? && !claimed? && parents.all?(&:done?)
    end

    def to_s
      "#{id}, Parents: #{parents.map(&:id).join(', ')}"
    end

    def ==(other)
      id == other.id
    end

    def add_parent(step)
      parents << step unless parents.include?(step)
    end

    def parents
      @parents ||= []
    end
  end
end

input = 'Step C must be finished before step A can begin.
Step C must be finished before step F can begin.
Step A must be finished before step B can begin.
Step A must be finished before step D can begin.
Step B must be finished before step E can begin.
Step D must be finished before step E can begin.
Step F must be finished before step E can begin.
'

instructions = Instructions.new(input)
puts instructions.each.map(&:id).join
puts instructions.duration(2, 0)
input = File.read('input')
instructions = Instructions.new(input)
puts instructions.each.map(&:id).join
puts instructions.duration(5, 60)

#!/usr/bin/env ruby

require "English"

class Schedule
  def initialize(logs)
    @guards = {}
    id = nil
    logs.lines.map(&:chomp).sort.each do |log|
      case log
      when /Guard #(?<id>\d+) begins shift/
        id = $LAST_MATCH_INFO['id'].to_i
        @guards[id] ||= Guard.new(id)
      when /:(?<min>\d+)\] falls asleep/
        min = $LAST_MATCH_INFO['min'].to_i
        @guards[id].fall_asleep(min)
      when /:(?<min>\d+)\] wakes up/
        min = $LAST_MATCH_INFO['min'].to_i
        @guards[id].wake_up(min)
      else
        raise "Invalid log: #{log}"
      end
    end

    def sleepiest_guard
      @guards.values.max_by(&:total_sleep)
    end

    def most_consistent_guard
      @guards.values.max_by(&:most_slept_times)
    end
  end

  class Guard
    def initialize(id)
      @id = id
      @sleeps = []
    end

    def code
      @id * most_slept_minute
    end

    def total_sleep
      @sleeps.map(&:size).sum
    end

    def most_slept
      (0...60).map do |min|
        [@sleeps.count { |sleep| sleep.include?(min) }, min]
      end.max
    end

    def most_slept_times
      times, _minute = most_slept
    end

    def most_slept_minute
      _times, minute = most_slept
      minute
    end

    def fall_asleep(min)
      @last_start = min
    end

    def wake_up(min)
      @sleeps << (@last_start...min)
    end
  end
end

input = '[1518-11-01 00:00] Guard #10 begins shift
[1518-11-01 00:05] falls asleep
[1518-11-01 00:25] wakes up
[1518-11-03 00:05] Guard #10 begins shift
[1518-11-04 00:02] Guard #99 begins shift
[1518-11-01 23:58] Guard #99 begins shift
[1518-11-01 00:55] wakes up
[1518-11-03 00:29] wakes up
[1518-11-02 00:50] wakes up
[1518-11-03 00:24] falls asleep
[1518-11-02 00:40] falls asleep
[1518-11-01 00:30] falls asleep
[1518-11-04 00:36] falls asleep
[1518-11-04 00:46] wakes up
[1518-11-05 00:03] Guard #99 begins shift
[1518-11-05 00:45] falls asleep
[1518-11-05 00:55] wakes up'

input = File.read('input')

schedule = Schedule.new(input)

puts schedule.sleepiest_guard.code
puts schedule.most_consistent_guard.code

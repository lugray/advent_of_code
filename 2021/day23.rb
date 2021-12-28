#!/usr/bin/env ruby

require_relative 'day'

class Day23 < Day
  class SortedList < Array
    def initialize(arr, &sort_by_fn)
      @sort_by_fn = sort_by_fn
      replace(arr.sort_by(&@sort_by_fn))
    end

    def <<(elem)
      elem_sort_val = @sort_by_fn.call(elem)
      i = bsearch_index do |e|
        @sort_by_fn.call(e) > elem_sort_val
      end || size
      insert(i, elem)
    end

    def delete(elem)
      elem_sort_val = @sort_by_fn.call(elem)
      i = bsearch_index do |e|
        @sort_by_fn.call(e) >= elem_sort_val
      end
      return unless i
      loop do
        break delete_at(i) if at(i).eql?(elem)
        i += 1
        break if i >= size
        break if @sort_by_fn.call(at(i)) > elem_sort_val
      end
    end
  end

  class State
    POD_POS = [2,4,6,8]
    VALID_STOPS = (0..10).to_a - POD_POS
    POD_TARGET = ["A", "B", "C", "D"]
    POD_FOR = {
      "A" => 0,
      "B" => 1,
      "C" => 2,
      "D" => 3,
    }
    STEP_ENERGY = {
      "A" => 1,
      "B" => 10,
      "C" => 100,
      "D" => 1000,
    }

    def initialize(hall, pods, pod_size)
      @hall = hall
      @pods = pods
      @pod_size = pod_size
    end

    def eql?(other)
      to_a.eql?(other.to_a)
    end

    def hash
      to_a.hash
    end

    def to_a
      [@hall, @pods]
    end

    def updown(a, b)
      Range.new(*([a,b].sort))
    end

    def pod_clean?(i)
      @pods[i].all? { |s| s == POD_TARGET[i] }
    end

    def pod_done?(i)
      pod_clean?(i) && @pods[i].length == @pod_size
    end

    def done?
      (0..3).all? { |i| pod_done?(i) }
    end

    def reduce
      e = 0
      loop do
        moved = false
        VALID_STOPS.each do |hall_pos|
          next unless (candidate = @hall[hall_pos])
          next unless pod_clean?(POD_FOR[candidate])
          if updown(hall_pos, POD_POS[POD_FOR[candidate]]).all? { |i| i == hall_pos || @hall[i].nil? }
            @hall[hall_pos] = nil
            e += ((hall_pos - POD_POS[POD_FOR[candidate]]).abs + @pod_size - @pods[POD_FOR[candidate]].count) * STEP_ENERGY[candidate]
            @pods[POD_FOR[candidate]].unshift(candidate)
            moved = true
          end
        end
        return e unless moved
      end
    end

    def next_states_with_energy_cost
      @pods.each_with_index.each do |pod, i|
        next [] if pod_clean?(i)
        VALID_STOPS.each do |hall_pos|
          next unless updown(hall_pos, POD_POS[i]).all? { |j| @hall[j].nil? }
          hall = @hall.dup
          pods = @pods.map(&:dup)
          mover = pods[i].shift
          hall[hall_pos] = mover
          s = State.new(hall, pods, @pod_size)
          e = ((hall_pos - POD_POS[i]).abs + @pod_size - pods[i].count) * STEP_ENERGY[mover] + s.reduce
          yield [s, e]
        end
      end
    end
  end

  def initialize
    @pods = input_lines.filter_map do |line|
      line.each_char.select { |c| ('A'..'D').include?(c) }
    end.reject(&:empty?).transpose
  end

  def energy_to_sort(pods)
    spent = Hash.new { Float::INFINITY }
    init = State.new(Array.new(11), pods, pods.first.size)
    spent[init] = 0
    states = SortedList.new([init]) { |state| spent[state] }
    loop do
      state = states.shift
      return spent[state] if state.done?
      state.next_states_with_energy_cost do |new_state, e|
        next unless spent[state] + e < spent[new_state]
        states.delete(new_state)
        spent[new_state] = spent[state] + e
        states << new_state
      end
    end
  end

  def part_1
    energy_to_sort(@pods)
  end

  def part_2
    pods = @pods.zip([
      ['D', 'D'],
      ['C', 'B'],
      ['B', 'A'],
      ['A', 'C'],
    ]).map { |orig, insert| [orig[0]] + insert + [orig[1]] }
    energy_to_sort(pods)
  end
end

Day23.run if __FILE__ == $0

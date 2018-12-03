#!/usr/bin/env ruby

class Boxes
  def initialize(boxes)
    @boxes = boxes
  end

  def checksum
    ns(2) * ns(3)
  end

  def match_part
    @boxes.each do |box1|
      @boxes.each do |box2|
        m = match(box1, box2)
        return m if m
      end
    end
  end

  private

  def ns(n)
    counts.count {|c| c.include?(n)}
  end

  def counts
    @boxes.map do |box|
      box.each_char.group_by(&:itself).map { |_, v| v.count }
    end
  end

  def match(box1, box2)
    equal_characters = box1.each_char.zip(box2.each_char).map do |c1, c2|
      c1 == c2 ? c1 : nil
    end
    if equal_characters.count {|b| b.nil? } == 1
      equal_characters.compact.join
    end
  end
end

boxes = Boxes.new(File.readlines('input').map(&:chomp))
puts boxes.checksum
puts boxes.match_part

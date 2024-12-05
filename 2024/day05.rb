#!/usr/bin/env ruby

require_relative 'day'

class Page
  attr_reader :n
  @rules = Hash.new(false)

  def self.require_order!(pair) = @rules[pair] = true
  def self.require_order?(a, b) = @rules[[a,b]]
  def initialize(n)             = @n = n
  def <=> (other)               = Page.require_order?(@n, other.n) ? -1 : Page.require_order?(other.n, @n) ? 1 : 0
end

class PageList
  def initialize(pages) = @pages = pages
  def sorted            = @sorted ||= @pages.sort
  def sorted?           = @pages == sorted
  def middle_page       = sorted[sorted.size/2].n
end

class Day05 < Day
  def initialize
    rules, lists = input_paragraphs
    rules.each_line { |line| Page.require_order!(line.split('|').map(&:to_i)) }
    @lists = lists.grid(sep: ',') { |n| Page.new(n.to_i) }.map { |pages| PageList.new(pages) }
  end

  def part_1
    @lists.select(&:sorted?).sum(&:middle_page)
  end

  def part_2
    @lists.reject(&:sorted?).sum(&:middle_page)
  end
end

Day05.run if __FILE__ == $0

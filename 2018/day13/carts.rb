#!/usr/bin/env ruby
require 'matrix'

class Track
  def initialize(input)
    @track, @carts = parse(input)
  end

  def find_crash
    loop do
      @carts.sort.each do |cart|
        move(cart)
        if @carts.any? { |c| c.crash_with?(cart) }
          return [cart.x, cart.y].join(',')
        end
      end
    end
  end

  def last_cart
    loop do
      @carts.sort.each do |cart|
        move(cart)
        if other = @carts.find { |c| c.crash_with?(cart) }
          cart.ignore!
          other.ignore!
        end
      end
      @carts = @carts.reject(&:ignored?)
      if @carts.length == 1
        cart = @carts.first
        return [cart.x, cart.y].join(',')
      end
    end
  end

  def move(cart)
    case track_at(cart)
    when '|', '-'
      cart.advance
    when '/'
      cart.turn(Cart::REFLECTB)
      cart.advance
    when '\\'
      cart.turn(Cart::REFLECTA)
      cart.advance
    when '+'
      cart.turn(cart.next_choice)
      cart.advance
    else
      raise "Unexpected track character: #{track_at(cart)}"
    end
  end

  def show
    @track.each_with_index.map do |row, y|
      row.each_with_index.map do |char, x|
        if @carts.any? {|c| c.x == x && c.y == y}
          'C'
        else
          char
        end
      end.join
    end.join("\n")
  end

  private

  def track_at(cart)
    @track[cart.y][cart.x]
  end

  def parse(input)
    carts = []
    track = input.lines.each_with_index.map do |line, y|
      line.chomp.each_char.each_with_index.map do |char, x|
        case char
        when '|', '-', '/', '\\', '+', ' '
          char
        when 'v'
          carts.push(Cart.new([x, y], [0, 1]))
          '|'
        when '^'
          carts.push(Cart.new([x, y], [0, -1]))
          '|'
        when '<'
          carts.push(Cart.new([x, y], [-1, 0]))
          '-'
        when '>'
          carts.push(Cart.new([x, y], [1, 0]))
          '-'
        else
          raise "Unexpected character in parse: #{char}"
        end
      end
    end
    [track, carts]
  end

  class Cart
    LEFT = Matrix[[0,1],[-1,0]]
    STRAIGHT = Matrix[[1,0],[0,1]]
    RIGHT = Matrix[[0,-1],[1,0]]

    REFLECTA = Matrix[[0, 1],[1,0]]
    REFLECTB = Matrix[[0, -1],[-1,0]]

    def initialize(loc, dir)
      @loc = Vector[*loc]
      @dir = Vector[*dir]
      @turns = [LEFT, STRAIGHT, RIGHT]
      @ignored = false
    end

    def x
      @loc[0]
    end

    def y
      @loc[1]
    end

    def turn(r)
      @dir = r * @dir
    end

    def advance
      @loc += @dir
    end

    def next_choice
      t = @turns.shift
      @turns.push(t)
      t
    end

    def <=>(other)
      a = y <=> other.y
      a == 0 ? (x <=> other.x) : a
    end

    def ignored?
      @ignored
    end

    def ignore!
      @ignored = true
    end

    def crash_with?(other)
      return false if ignored? || other.ignored?
      self != other && @loc == other.loc
    end

    attr_reader :loc
  end
end

input = '/->-\
|   |  /----\
| /-+--+-\  |
| | |  | v  |
\-+-/  \-+--/
  \------/
'
input = File.read('input')
puts Track.new(input).find_crash
puts Track.new(input).last_cart

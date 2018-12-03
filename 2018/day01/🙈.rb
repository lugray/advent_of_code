#!/usr/bin/env ruby
puts eval("0" + File.read('input').lines.map(&:chomp).join)

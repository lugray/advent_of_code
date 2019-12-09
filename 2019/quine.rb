#!/usr/bin/env ruby

require_relative 'day'
require_relative 'intcode'

intcode = [
  109, 1,
  204, -1,
  109, 1,
  1205, -1, 2,
  99,
]
outcode = Intcode.new(intcode).run.outputs
puts outcode
puts outcode == intcode

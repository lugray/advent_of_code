#!/usr/bin/env ruby

require 'open3'

exprs = File.readlines('day02.input', chomp: true)
  .map { |l| "(round-score #{l})" }
  .join("\n")

smt2 = File.read('day02.smt2.tpl').sub('%EXPRS%', exprs)
o, e, s = Open3.capture3('z3', '-smt2', '-in', stdin_data: smt2)
STDOUT.puts o
STDERR.puts e
exit s.exitstatus

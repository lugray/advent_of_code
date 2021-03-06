#!/usr/bin/env ruby

require "minitest/autorun"

class TestDays < Minitest::Test
  Dir.glob(File.join(File.dirname(__FILE__), 'day??.rb')).sort.each do |f|
    define_method("test_#{f}") do
      basename = File.basename(f, '.rb')
      outfile = "#{basename}.output"
      skip "Missing output file #{outfile}" unless File.exist?(outfile)
      skip "Too long" if basename == 'day12'
      skip "Too long" if basename == 'day16'
      skip "Too long" if basename == 'day18'
      skip "Too long" if basename == 'day20'
      require_relative basename
      assert_equal File.read(outfile), Object.const_get(basename.capitalize).output
    end
  end
end

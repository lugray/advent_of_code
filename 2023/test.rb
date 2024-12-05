#!/usr/bin/env ruby

require "minitest/autorun"
require "minitest/reporters"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

class TestDays < Minitest::Test
  Dir.glob(File.join(File.dirname(__FILE__), 'day??.rb')).sort.each do |f|
    basename = File.basename(f, '.rb')
    define_method("test_#{basename}") do
      outfile = "#{basename}.output"
      skip "Missing output file #{outfile}" unless File.exist?(outfile)
      skip "#{basename} too long" if ["day12", "day14", "day16", "day17"].include?(basename)
      require_relative basename
      assert_equal File.read(outfile), Object.const_get(basename.capitalize).output
    end
  end
end

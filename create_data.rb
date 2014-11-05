#/usr/bin/env ruby

require_relative "generator"
require_relative "loader"

loader = Loader.new()

# Testing with a value of 10
generate(10, loader)

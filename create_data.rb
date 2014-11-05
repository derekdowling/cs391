#/usr/bin/env ruby

require_relative "generator"
require "thor"
require_relative "loader"

class CreateData < Thor
    desc "n", "Generate n documents"
    def numDocs(n = 1)
        generate(n)
    end
end

CreateData.start(ARGV)

# Testing with a value of 10
#generate(10)

loader = Loader.new()

# Testing with a value of 10
generate(10, loader)

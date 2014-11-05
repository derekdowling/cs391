#/usr/bin/env ruby

require_relative "generator"
require "thor"

class CreateData < Thor
    desc "n", "Generate n documents"
    def numDocs(n = 1)
        generate(n)
    end
end

CreateData.start(ARGV)

# Testing with a value of 10
#generate(10)



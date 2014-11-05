#/usr/bin/env ruby

require_relative "generator"
require "thor"
require_relative "loader"

class CreateData < Thor
    option :loader, :type => :boolean, :desc => "Indicate if we want to use a Loader."
    desc "gen", "Generate n documents."
    long_desc <<-LONGDESC
    create_date gen will generate the number of documents specified.
 
    [--loader] Passes a loader to generate(). If this flag is not used, generate() will not 
    use a loader by default.
    LONGDESC

    def gen(n)
        # Convert number of documents to generate to an interger 
        n = n.to_i

        # Generate n documents, use a loader if called with loader flag. 
        if options[:loader]
            puts "Using a loader"
            loader = Loader.new()
            generate(n, loader)
        else
            puts "Not using a loader"
            generate(n)
        end
    end 
end

CreateData.start(ARGV)

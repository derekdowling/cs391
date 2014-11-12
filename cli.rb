#/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require "thor"

require_relative "generator"
require_relative "loader"

# This is a CLI tool that handles the generation and loading of data for our elastic search profiler.
class CLI < Thor

    # CLI Commands
    long_desc <<-LONGDESC
    cli:
    gen will generate the number of documents specified and optionally load them into ES
    query -- NOT YET IMPLEMENTED -- use to run elastic search queries through
    ping will output the health of our ES cluster

    Notes:
    [--driver] Passes our ES driver to generate(). If this flag is not set, gen will output results to STDOUT
    LONGDESC

    desc "gen", "Generate n documents from json manifest and optionally load into ES"
    option :driver, :type => :boolean, :desc => "Indicate if we want to use a driver."
    option :manifest, :type => :string, :desc => "NOT YET IMPLEMENTED, allows you to specify a specific manifest"
    def gen(num_docs)
        # Convert number of documents to generate to an interger 
        num_docs = num_docs.to_i
        generator = Generator.new

        # Generate n documents, and loads them into elastic search. 
        if options[:driver]
            puts "Loading results into ES"
            loader = Loader.new
            generator.setDriver(loader)
        end

        start_ts = Time.now

        # generate and output
        generator.generate(num_docs)

        stop_and_stat(start_ts, "load " << num_docs << "docs")
    end

    desc "query", "-- NOT YET IMPLEMENTED -- use to run elastic search queries through"
    def query(json)
        start_ts = Time.now

        # TODO: implement this with arguements   

        stop_and_stat(start_ts, "query")
    end

    desc "ping", "Tests our elastic search connection"
    def ping()
        loader = Loader.new
        loader.testConnection()
    end

    ########################
    # Helper Functions Below
    ########################

    # this makes thor not complain about these helpers
    no_commands do 
        # stops profiling metrics and prints to STDOUT
        # context allows you to pass in some arbitrary statistics to output, we
        # may want to look into a profiling gem that can probably do this way better
        # out of the box
        def stop_and_stat(start_time, context)
            # stop metrics and calculate
            end_time = Time.now
            elapsed = (end_time - start_time) * 1000.0
            puts "Finished at #{start_time}"
            puts "Took #{elapsed} seconds to #{context}"
        end
    # end of no_commands
    end
end

# Start CLI and pass in cmd line args
CLI.start(ARGV)
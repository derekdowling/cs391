#/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require "thor"

require_relative "generator"
require_relative "loader"

# This is a CLI tool that handles the generation and loading of data for our elastic search profiler.
class CLI < Thor

    # Profiling variabes
    @start_time
    @end_time

    # CLI options parameter
    option :driver, :type => :boolean, :desc => "Indicate if we want to use a driver."
    option :manifest, :type => :string, :desc => "NOT YET IMPLEMENTED, allows you to specify a specific manifest"
    option :profile, :type => :boolean, :desc => "NOT YET IMPLEMENTED, Adds profiling to the given call"

    # CLI Commands
    desc "gen", "Generate n documents from json manifest and optionally load into ES"
    desc "query", "-- NOT YET IMPLEMENTED -- use to run elastic search queries through"

    long_desc <<-LONGDESC
    clo:
    gen will generate the number of documents specified and optionally load them into ES
    query -- NOT YET IMPLEMENTED -- use to run elastic search queries through

    Notes:
    [--driver] Passes our ES driver to generate(). If this flag is not set, gen will output results to STDOUT
    LONGDESC

    # Our data generation/loading command
    # TODO: convert generator to a class with a configurable driver
    # that we can define via a setter so that we can clean up this function
    # and add profiling more easily
    def gen(num_docs)
        # Convert number of documents to generate to an interger 
        num_docs = num_docs.to_i
        generator = Generator.new

        # Generate n documents, and loads them into elastic search. 
        if options[:driver]
            puts "Loading results into ES"
            loader = Loader.new()
            generator.setDriver(loader)
        end

        if options[:profile]
            start_profiler
        end

        # generate and output
        generator.generate(num_docs)

        if options[:profile]
            stop_and_stat("load " << num_docs << "docs")
        end
    end

    # Used to run queries through our ES Driver
    def query(json)
        if options[:profile]
            start_profiler
        end

        # TODO: implement this with arguements   

        if options[:profile]
            stop_and_stat("query")
        end
    end

    # captures and sets up profiling metrics
    def start_profiler
        puts "Starting at " << Time.now
        @start_time = Time.now
    end

    # stops profiling metrics and prints to STDOUT
    # context allows you to pass in some arbitrary statistics to output, we
    # may want to look into a profiling gem that can probably do this way better
    # out of the box
    def stop_and_stat(context)
        # stop metrics and calculate
        @end_time = Time.now
        @elapsed = (@end_time - @start_time) * 1000.0

        # output results
        puts "Finised at " << @end_time
        puts "Took " << @elapsed << " seconds to " << context
    end
end

# Start CLI and pass in cmd line args
CLI.start(ARGV)

#/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require "thor"

require_relative "generator"
require_relative "elastic"

# This is a CLI tool that handles the generation and loading of data for our elastic search profiler.
class CLI < Thor

    desc "gen <num_docs>", "Generates <num_docs> from a JSON manifest"
    option :driver, :type => :boolean, :aliases => :d, :desc => "Indicate if we are using the Elastic Driver"
    option :manifest, :type => :string, :desc => "NOT YET IMPLEMENTED, allows you to specify a specific manifest"
    option :cluster, :type => :boolean, :aliases => :c, :desc => "Perform actions against the cluster if we are using the Elastic driver"
    option :benchmark, :type => :boolean, :aliases => :b, :desc => "Benchmarks query while performing it"
    def gen(num_docs)
        # Convert number of documents to generate to an interger 
        num_docs = num_docs.to_i
        generator = Generator.new

        # Generate n documents, and loads them into elastic search. 
        if options[:driver] || [:cluster]
            puts "Loading results into ES"
            elastic = Elastic.new

            if options[:cluster]
                elastic.useCluster()
            end
            generator.setDriver(elastic)
        end

        start_ts = Time.now

        # generate and output
        generator.generate(num_docs)

        stop_and_stat(start_ts, "load " << num_docs << "docs")
    end

    desc "query <json>", "-- NOT YET IMPLEMENTED -- use to run elastic search queries through"
    option :cluster, :type => :boolean, :aliases => :c, :desc => "Perform actions against the cluster"
    option :benchmark, :type => :boolean, :aliases => :b, :desc => "Benchmarks query while performing it"
    def query(json)
        elastic = Elastic.new
        if options[:cluster]
            elastic.useCluster()
        end

        if options[:benchmark]
            elastic.query(JSON.parse(json), true)
        else
            elastic.query(JSON.parse(json))
        end
    end

    desc "ping", "Tests our elastic search connection"
    option :cluster, :type => :boolean, :aliases => :c, :desc => "Perform actions against the cluster"
    def ping()

        elastic = Elastic.new

        if options[:cluster]
            elastic.useCluster()
        end

        elastic.testConnection()
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

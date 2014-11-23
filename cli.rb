#/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require "thor"

require_relative "generator"
require_relative "elastic"

# This is a CLI tool that handles the generation and loading of data for our elastic search profiler.
class CLI < Thor

    desc "gen <num_docs>", "Generates <num_docs> from a JSON manifest"
    option :dev, :type => :boolean, :aliases => :d, :desc => "Connects to your local Dev ES Instance"
    option :manifest, :type => :string, :desc => "NOT YET IMPLEMENTED, allows you to specify a specific manifest"
    option :cluster, :type => :boolean, :aliases => :c, :desc => "Perform actions against the cluster if we are using the Elastic driver"
    option :benchmark, :type => :boolean, :aliases => :b, :desc => "Benchmarks query while performing it"
    option :hardcore, :type => :boolean, :aliases => :h, :desc => "Used when loading to the cluster locally"
    option :threads, :type => :numeric, :aliases => :t, :desc => "Number of threads to use, defaults to one"
    def gen(num_docs)
        # Convert number of documents to generate to an interger 
        num_docs = num_docs.to_i
        generator = Generator.new
        # thread_count = 1
        # threads = []

        # Generate n documents, and loads them into elastic search. 
        if options[:driver] || options[:cluster] || options[:hardcore]
            puts "Loading results into ES"
            elastic = Elastic.new

            if options[:hardcore]
                elastic.useLocalCluster()
            elsif options[:cluster]
                elastic.useCluster()
            end
            generator.setDriver(elastic)
        end

        # if options[:threads]
            # thread_count = options[:threads]
        # end

        generator.generate(num_docs)

        # thread_count.times {
            # # spawn threads
            # threads << Thread.new {
                # puts "startin"
                # # generate and output
                # generator.generate(num_docs)
            # }
        # }

        # # collect threads
        # threads.each { |thr|
            # thr.join
        # }

        puts "Done"
    end

    long_desc <<-END
        Query docs: http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API/Actions#search-instance_method
        Cluster query example:
            query '{"physical_source":{"country":"USA"}}' -c
    END
    desc "search", "Find data in elastic search"
    option :cluster, :type => :boolean, :aliases => :c, :desc => "Perform query against the cluster"
    option :benchmark, :type => :boolean, :aliases => :b, :desc => "Benchmarks query while performing it"
    def query(json)
        elastic = Elastic.new
        if options[:cluster]
            elastic.useCluster()
        end

        query = JSON.parse(json)

        if options[:benchmark]
            elastic.search(query, true)
        else
            elastic.search(query)
        end
    end

    desc "ping", "Tests our elastic search connection"
    option :cluster, :type => :boolean, :aliases => :c, :desc => "Perform actions against the cluster"
    option :stats, :type => :boolean, :aliases => :s, :desc => "Also prints cluster stats"
    option :nodes, :type => :boolean, :aliases => :n, :desc => "Also prints node settings"
    def ping()

        elastic = Elastic.new

        if options[:cluster]
            elastic.useCluster()
        end

        elastic.testConnection(options[:stats],options[:nodes])
    end

    desc "mode", "Changes various cluster settings"
    option :bulk, :type => :boolean, :aliases => :b, :desc => "Optimizes settings for bulk loading"
    option :search, :type => :boolean, :aliases => :s, :desc => "Turns the cluster to search mode" 
    def mode()
        if options[:bulk]
            elastic.mode(true)
        end
        if options[:search]
            elastic.mode(false)
        end
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
            elapsed = (end_time - start_time)
            puts "Finished at #{start_time}"
            puts "Took #{elapsed} seconds to #{context}"
        end
    # end of no_commands
    end
end

# Start CLI and pass in cmd line args
CLI.start(ARGV)

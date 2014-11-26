#/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require "thor"
require "json"

require_relative "generator"
require_relative "elastic"

# This is a CLI tool that handles the generation and loading of data for our elastic
# search profiler.
class CLI < Thor

    long_desc <<-END
        Loads data in bulk to elastic search, 2500 documents at a time. By default it
        uploads data to your vagrant elastic search at 10.1.3.8:9200.
    END
    desc "gen <manifest_file> <num_docs>", "Generates <num_docs> from a JSON manifest"
    option :cluster, :type => :boolean, :aliases => :c, :desc => "Perform actions against the remote cluster"
    option :local, :type => :boolean, :aliases => :n, :desc => "Used to load data to the local cluster"
    option :threads, :type => :numeric, :aliases => :t, :desc => "Number of threads to use, defaults to one"
    def gen(manifest, num_docs)
        # Convert number of documents to generate to an interger 
        num_docs = num_docs.to_i
        generator = Generator.new

        # Generate n documents, and loads them into elastic search. 
        if options[:cluster] || options[:local]
            puts "Loading results into ES"
            elastic = Elastic.new

            if options[:local]
                elastic.useLocalCluster()
            elsif options[:cluster]
                elastic.useCluster()
            end
            generator.setDriver(elastic)
        end

        generator.generate(manifest, num_docs)

        puts "Done"
    end

    long_desc <<-END
        Query docs: http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API/Actions#search-instance_method
        Cluster query example:
            search flat_transactions flat_queries.json -c -q 1
    END
    desc "search <index> <rel_json_file>", "Find data in elastic search"
    option :cluster, :type => :boolean, :aliases => :c, :desc => "Perform query against the cluster"
    option :query, :type => :numeric, :aliases => :q, :desc => "Specify a specific index from the list of queries to execute"
    def search(index, json_file)

        queries = {}
        elastic = Elastic.new
        if options[:cluster]
            elastic.useCluster()
        end

        file = File.read(json_file)
        queries = JSON.parse(file)["queries"]

        if options[:query]
            queries = queries[options[:query]]
        end

        elastic.search(index, queries)
    end

    desc "ping", "Tests our elastic search connection and optional returns stats and configurations"
    option :stats, :type => :boolean, :aliases => :s, :desc => "Also indice stats"
    option :config, :type => :boolean, :aliases => :c, :desc => "Include indice config"
    def ping()

        elastic = Elastic.new
        elastic.useCluster()

        elastic.testConnection(options[:stats],options[:config])
    end
end

# Start CLI and pass in cmd line args
CLI.start(ARGV)

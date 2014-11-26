require "elasticsearch"
require "pp"

# Our elastic search driver class. Handles various things such as connecting,
# pinging, loading, and searching.
# docs: http://www.rubydoc.info/gems/elasticsearch-api/
class Elastic

    def initialize()
        @target = '10.1.3.8:9200'
        @client = nil
    end

    def useCluster()
        @target = '199.116.235.83:9200'
    end

    def useLocalCluster()
        @target = "localhost:9200"
    end

    def connect()
        if @client.nil?
            @client = Elasticsearch::Client.new host: @target
        end
        return @client
    end

    def testConnection(stats = false, config = false)
        pp connect().cluster.health
        # pp connect().cluster.state
        # pp connect().cluster.get_settings

        if stats
            pp connect().indices.stats
        end
        if config
            pp connect().indices.get_settings
        end
    end

    # Use this to bulk load data into ES
    def bulk_load(objs)
        # Upload the array of objects we received
        connect().bulk body: objs
    end

    # Performs a benchmarked search/query in ES
    def search(index, queries)

        $i = 0;
        while $i < queries.length do

            # perform query
            data = connect().search index: index, body: queries[$i]

            puts query: $i, result: data
            $i = $i + 1
        end
    end
end

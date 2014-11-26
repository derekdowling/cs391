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
    def search(index, queries, runs)

        $q = 0;
        while $q < queries.length do

            result = { :query =>  $q, :runs => runs }
            time = 0
            data = {}

            $r = 0
            while $r < runs do

                # clear cache so our results don't suck
                connect().indices.clear_cache index: index

                # let ES recover
                sleep 0.5

                # perform query
                data = connect().search index: index, body: queries[$q]

                time = time + data["took"].to_f
                $r = $r + 1
            end

            result["avg"] = time / runs
            result["example"] = data

            pp result
            $q = $q + 1
        end
    end
end

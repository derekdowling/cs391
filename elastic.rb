require "elasticsearch"
require "pp"

# docs: http://www.rubydoc.info/gems/elasticsearch-api/
class Elastic

    @target = '10.1.3.8:9200'
    @client = nil

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

    def testConnection()
        puts connect().cluster.health
        pp connect().indices.stats()
    end

    # Use this to bulk load data into ES
    def bulk_load(objs)
        # Upload the array of objects we received
        puts "loading into es"
        connect().bulk body: objs
    end

    def search(query, benchmark = false)
        if benchmark
            puts connect().benchmark body: {
                name: "query_benchmark",
                competitors: {
                    name: "query",
                    requests: [
                        { query: query }
                    ]
                }
            }
        else
            puts connect().search query
        end
    end
end

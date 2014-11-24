require "elasticsearch"
require "pp"

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
        pp connect().cluster.get_settings

        if stats
            pp connect().indices.stats index: 'transactions'
        end
        if config
            pp connect().indices.get_settings index: 'transactions'
        end
    end

    # Use this to bulk load data into ES
    def bulk_load(objs)
        # Upload the array of objects we received
        connect().bulk body: objs
    end

    def search(query, benchmark = false)
        if benchmark
            pp connect().benchmark index: 'transactions', body: {
                name: "query_benchmark",
                competitors: [
                    {
                        name: "query",
                        requests: [
                            { query: query }
                        ]
                    }
                ]
            }
        else
            pp connect().search index: 'transactions', q: query
        end
    end

    def mode(bulk)
        if bulk
            client().cluster.put_settings body: { 
                transient: { 'cluster.routing.allocation.disable_allocation' => true } 
            }
        else
            client().cluster.put_settings body: { 
                transient: { 'cluster.routing.allocation.disable_allocation' => true } 
            }
        end
    end
end

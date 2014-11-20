require "elasticsearch"

class Loader

    @target

    # Constructor, add state here
    def initialize(target = '10.1.3.8:9200')
        @target = target
    end

    def connect()
        #client = Elasticsearch::Client.new host: '10.1.3.8:9200'
        client = Elasticsearch::Client.new host: @target
        return client
    end

    def testConnection()
        client = connect()
        puts client.cluster.health
    end

    def puts(objs)
        # Connect to the server
        client = connect()

        # Upload the array of objects we received
        client.bulk body: objs
    end

    def close()
        # not gonna use it. Placeholder
    end
end

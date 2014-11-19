require "elasticsearch"

class Loader

    # Constructor, add state here
    def initialize()
    end

    def populate()
        client = connect()
        upload(client)
    end

    def connect()
        #client = Elasticsearch::Client.new host: '10.1.3.8:9200'
        client = Elasticsearch::Client.new host: 'localhost:9200'
        return client
    end

    def testConnection()
        client = connect()
        puts client.cluster.health
    end

    def upload(client, obj)
        client.bulk body: [
                { index:  { _index: 'test', _type: 'json' } },
                {data:obj} 
        ]
    end

    def puts(*objs)
        # Connect to the server
        client = connect()

        # Upload the obj we received
        upload(client, objs)
    end

    def close()
        # not gonna use it. Placeholder
    end
end

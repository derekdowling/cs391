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
        client = Elasticsearch::Client.new host: '10.1.3.8:9200'
        return client
    end

    def testConnection()
        client = connect()
        puts client.cluster.health
    end

    def upload(client, json)
        client.bulk body: [
                { index:  { _index: 'myindex', _type: 'mytype', _id: 1, data: json } },
        ]
    end

    def puts(*objs)
        output = IO.new STDOUT.fileno
        output.puts objs
    end

    def close()
        # not gonna use it. Placeholder
    end
end

require "elasticsearch"
require "generator.rb"

def populate()
    client = connect()
    upload(client)
end

def connect()
    client = Elasticsearch::Client.new host: '10.1.3.8:9200'
    return client
end

def upload(client, json)
    client.bulk body: [
            { index:  { _index: 'myindex', _type: 'mytype', _id: 1, data: { title: 'foo' } } },
    ]
end

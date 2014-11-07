# This file will be used to handle the actual querying of data once we
# introduce the elastic search cluster through the transport gem all other
# interactions should be handled using the base elasticsearch gem.

require "elasticsearch/transport"

class querier

	def connect()
	    client = Elasticsearch::Client.new host: '10.1.3.8:9200'
	    response = client.perform_request 'GET', '_cluster/health'
	    puts response
	end


	def testConnection()
		client = connect()
		puts client.cluster.health
	    end


	def close()
	    # close off connection to Elasticsearch here
	end
end
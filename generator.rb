require 'json'

# Call this to generate json output
# Has some default values for parameters, can pass in own values
def generate(documents = 1, output = IO.new(STDOUT.fileno))

    puts "Starting data generation"

    # load manifest from file
    key_values = parseManifest()
    # start generating json objects
    createJson(output, key_values, documents)
end

# Loads the manifest file, parses it to Json, returns the hash
def parseManifest()

    puts "Parsing manifest file"

    file = File.read('manifest.json')
    key_values = JSON.parse(file)
    puts key_values

    return key_values
end

# Create JSON objects until count is reached,
# each time calling
def createJson(buffer, manifest, count)

    puts "Starting json output"

    i = 0
    while i < count

        puts "Generating " << i + 1 << " of " << count

        #generate data, this is a place holder below
        json_obj = ''

        #generate random inputs based on keys/values(types) provided from
        #manifest

        #output data to specified buffer
        buffer.puts JSON.pretty_generate(json_obj)
    end

    # finally close our buffer
    puts "Finished, closing buffer"
    buffer.close()
    puts "Goodbye!"
end 

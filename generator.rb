require 'json'


class Generator

    # the output driver to use
    @driver

    # sets up the Generator
    def initialize(driver = IO.new(STDOUT.fileno))
        @driver
    end

    def setDriver(driver)
        @driver = driver
    end

    # Call this to generate json output
    # Has some default values for parameters, can pass in own values
    def generate(documents = 1)

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

            #puts "Generating " << i + 1 << " of " << count
            puts "Generating #{i+1} of #{count}"

            #generate random inputs based on keys/values(types) provided from
            #manifest
            json_obj = manifest.clone
            json_obj.each {|key, val| json_obj[key] = getRandom(val)}

            #output data to specified buffer
            @driver.puts JSON.pretty_generate(json_obj)

            i = i + 1
        end

        # finally close our buffer
        puts "Finished, closing buffer"
        buffer.close()
        puts "Goodbye!"
    end 

    # Given the type of data needed, generates random data
    # I used random number for the max vals, feel free to change
    def getRandom(value_type)
        my_prng = Random.new(seed = Random.new_seed)
        if value_type == 'float'
            # Takes any float between 0 and 10,000.00...
            # Rounds to 2 decimal places
            return my_prng.rand(10000.0).round(2)
        elsif value_type == 'int'
            # Int between 0 and 100,000
            return my_prng.rand(100000)
        elsif value_type == 'string'
            # String of 20 random letters
            return ('a'..'z').to_a.shuffle[0,20].join
        else
            return 0
        end
    end
end

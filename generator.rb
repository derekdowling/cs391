require 'json'
require 'rubygems'
require 'faker'

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
        createData(@driver, key_values, documents)
    end

    # Loads the manifest file, parses it to Json, returns the hash
    def parseManifest()

        puts "Parsing manifest file"

        file = File.read('manifest.json')
        key_values = JSON.parse(file)
        puts key_values

        return key_values
    end

    def copyHash(value)
        if value.is_a?(Hash)
            result = value.clone()
            value.each{|k,v| result[k] = copyHash(v)}
            return result
        else
            return value
        end
    end
    
    # Create JSON objects until count is reached,
    # each time calling
    def createData(buffer, manifest, count)

        puts "Starting data output"

        i = 0
        while i < count
            puts ""
            puts "Generating #{i+1} of #{count}"

            #generate random inputs based on keys/values(types) provided from
            #manifest
            data_hash = copyHash(manifest)
            data_hash.each{|key, val| data_hash[key] = decomposeHash(key, val)}

            
            i = i + 1
        end

        puts ""

        puts "Finished data generation!"
    end

    # Fills out each element of the hash with random data.
    def decomposeHash(key, val)
        # If value is NOT a hash, we are done!
        if !(val.is_a?(Hash))
            newval = getRandom(val)
            puts "#{key}: #{newval}"
            return newval
        end

        # Decompose the hash
        val.each do |key1, val1|
            val[key1] =  decomposeHash(key1, val1)
        end

    end

    # Given the type of data needed, generates random data
    # Generates: float, int, string, address, name, city
    def getRandom(value_type)
        catch (:wrong_type) do
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
            elsif value_type == 'address'
                return Faker::Address.street_address
            elsif value_type == 'name'
                return Faker::Name.name
            elsif value_type == 'city'
                return Faker::Address.city
            elsif value_type == 'phone_num'
                return Faker::PhoneNumber.cell_phone
            elsif value_type == 'email'
                return Faker::Internet.email
            elsif value_type == 'bitcoin'
                return Faker::Bitcoin.address
            elsif value_type == 'time'
                # Uses 24 hour time and uses format hh:mm:ss
                hour = my_prng.rand(24).to_s
                min = my_prng.rand(59)
                if (min < 10)
                    min = min.to_s
                    min = "0"+min
                end
                sec = my_prng.rand(59)
                if (sec < 10)
                    sec = sec.to_s
                    sec = "0"+sec
                end
                return hour+":"+"#{min}"+":#{sec}"
            else
                puts "Ran into a problem while generating data:"
                puts "Cannot generate random data for type '#{value_type}'."
                throw :wrong_type
            end
        end
    end
end

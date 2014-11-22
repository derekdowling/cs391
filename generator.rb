require 'json'
require 'rubygems'
require 'faker'
require 'ruby-prof'

class Generator

    # the output driver to use
    def initialize()
        @driver = IO.new(STDOUT.fileno)
        @manifest = {}
        @name = [ "Jane" , "Bob", "Tim", "Joanne", "Lucy", "Jessica", "Tony", "Jason", "Rex", "Jas", "Alex" ]
        @country = [ "CA", "USA", "MEX", "UK", "FR", "GER", "DL", "GRC", "ESP" ]
        @email = [ "123@gmail.com", "sweetdood@yahoo.com", "edm@msn.ca", "llcoolj@gmail.com", "wasabi@gov.ab.ca" ]
        @business = [ "SuperHoldings LTD", "Walmart", "Superstore", "Italian Centre", "Best Buy", "Future Shop", "Sears", "Zellers" ]
    end

    def setDriver(driver)
        @driver = driver
    end

    # Call this to generate json output
    # Has some default values for parameters, can pass in own values
    def generate(documents = 1)
        puts "Starting data generation"

        # load manifest from file
        parseManifest()

        # start generating json objects
        createData(@driver, documents)
    end

    # Loads the manifest file, parses it to Json, returns the hash
    def parseManifest()
        puts "Parsing manifest file"

        file = File.read('manifest.json')
        @manifest = JSON.parse(file)
    end

    def copyHash(hash)
        return Marshal.load(Marshal.dump(hash))
    end

    # Create objects until count is reached
    def createData(buffer, count)

        puts "Starting generation"

        # counters
        gen_count = 0
        bulk_max = 450

        doc_size = 3000.0
        dgh = doc_size * 3600.0 / 1000000000.0

        # tuning variables
        last_exec_ratio = 0.0
        exec_ratio = 0.0
        while gen_count < count do

            puts last_exec_ratio
            puts exec_ratio
            # tuning
            if exec_ratio > last_exec_ratio
                bulk_max += 20
            else
                bulk_max -= 20
            end

            # save our last exec ratio
            last_exec_ratio = exec_ratio

            # Create an array to hold all of our generated documents for each
            # bulk upload
            obj_arr = []
            bulk_count = 0

            puts "Next:#{bulk_max} - Current:#{gen_count}/#{count}"
            start_time = Time.now

            while gen_count < count && bulk_count < bulk_max do

                # RubyProf.start
                #generate random inputs based on keys/values(types) provided from
                #manifest
                data_hash = {}
                @manifest.each do |key, val|
                    data_hash[key] = decomposeHash(key, val)
                end

                # result = RubyProf.stop
                # printer = RubyProf::FlatPrinter.new(result)
                # printer.print(STDOUT)

                # Add an element to the array specifying we want to index, then add the object to index.
                obj_arr.push({ index: { _index: 'customer', _type: 'payments'} },{ data: data_hash })

                gen_count += 1
                bulk_count += 1
            end

            # upload all the documents we generated in bulk
            if @driver.is_a?(Elastic)
                @driver.bulk_load(obj_arr)
            else
                puts obj_arr
            end

            # Tuning Vars and Output
            end_time = Time.now
            exec_time = end_time - start_time
            exec_ratio = bulk_count / exec_time
            gph = exec_ratio * dgh
            puts "#T:#{exec_time} #C:#{bulk_count+1} #R:#{exec_ratio} #G/H:#{gph}"

        end
        puts "Finished data generation!"
    end

    # Fills out each element of the hash with random data.
    def decomposeHash(key, val)
        # If value is NOT a hash, we are done!
        if !val.is_a?(Hash)
            return getRandom(val)
        end

        # Decompose the hash
        hash = {}
        val.each do |key1, val1|
            hash[key1] =  decomposeHash(key1, val1)
        end
        return hash

    end

    # Given the type of data needed, generates random data
    # Generates: float, int, string, address, name, city
    def getRandom(value_type)
        catch (:wrong_type) do
            my_prng = Random.new(Random.new_seed)
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
            elsif value_type == 'small_int'
                # Int between 0 and 30,000
                # Want to keep this number fairly small so we
                # have more interesting queries
                return my_prng.rand(30000)
            elsif value_type == 'id'
                return my_prng.rand(100000)
            elsif value_type == 'address'
                return my_prng.rand(99999)
            elsif value_type == 'name'
                return @name[my_prng.rand(@name.length - 1)]
            elsif value_type == 'city'
                return Faker::Address.city
            elsif value_type == 'phone_num'
                return my_prng.rand(9999999999)
            elsif value_type == 'email'
                return @email[my_prng.rand(@email.length - 1)]
            elsif value_type == 'country'
                return @country[my_prng.rand(@country.length - 1)]
            elsif value_type == 'ip'
                return Faker::Internet.ip_v4_address
            elsif value_type == 'latitude'
                return Faker::Address.latitude
            elsif value_type == 'longitude'
                return Faker::Address.longitude
            elsif value_type == 'zip'
                return my_prng.rand(99999)
            elsif value_type == 'credit_card_num'
                return Faker::Business.credit_card_number
            elsif value_type == 'credit_card_type'
                # (Ex) Visa
                return Faker::Business.credit_card_type
            elsif value_type == 'credit_card_expiry_date'
                return Faker::Business.credit_card_expiry_date
            elsif value_type == 'company'
                return @business[my_prng.rand(@business.length - 1)]
            elsif value_type == 'ein'
                # Employee ID
                return Faker::Company.ein
            elsif value_type == 'duns_num'
                return Faker::Company.duns_number
            elsif value_type == 'date'
                # Random date in the past 1000 days
                return Faker::Date.backward(1000)
            elsif value_type == 'job_title'
                return Faker::Name.title
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

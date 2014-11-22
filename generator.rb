require 'json'
require 'rubygems'
require 'ruby-prof'
require 'date'

class Generator

    # the output driver to use
    def initialize()
        @driver = IO.new(STDOUT.fileno)
        @manifest = {}
        @name = [ "Jane" , "Bob", "Tim", "Joanne", "Lucy", "Jessica", "Tony", "Jason", "Rex", "Jas", "Alex" ]
        @country = [ "CA", "USA", "MEX", "UK", "FR", "GER", "DL", "GRC", "ESP" ]
        @email = [ "123@gmail.com", "sweetdood@yahoo.com", "edm@msn.ca", "llcoolj@gmail.com", "wasabi@gov.ab.ca" ]
        @business = [ "SuperHoldings LTD", "Walmart", "Superstore", "Italian Centre", "Best Buy", "Future Shop", "Sears", "Zellers" ]
        @city = [ "Edmonton", "London", "Paris", "Munich", "Athens", "Barcelona", "Mexico City", "New York", "Calgary", "Austin" ]
        @ip = [ "123.673.683.23", "123.379.231.547", "234.732.134.564", "234.437.243.12", "123.675.234.785", "234.547.321.673", "235.458.234.83" ]
        @rand = Random.new(Random.new_seed)
        @cc = [ "Visa", "Mastercard", "American Express", "Maestro", "Discovery", "Diner's Club" ]
        @job = [ "CEO", "CFO", "CIO", "CTO", "Department Manager", "Employee", "Intern", "VP", "Board Member" ]
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

            # RubyProf.start

            while gen_count < count && bulk_count < bulk_max do

                #generate random inputs based on keys/values(types) provided from
                #manifest
                data_hash = {}
                @manifest.each do |key, val|
                    data_hash[key] = decomposeHash(key, val)
                end


                # Add an element to the array specifying we want to index, then add the object to index.
                obj_arr.push({ index: { _index: 'customer', _type: 'payments'} },{ data: data_hash })

                gen_count += 1
                bulk_count += 1
            end

            # result = RubyProf.stop
            # printer = RubyProf::FlatPrinter.new(result)
            # printer.print(STDOUT)

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
            if value_type == 'float'
                # Takes any float between 0 and 10,000.00...
                # Rounds to 2 decimal places
                return @rand.rand(10000.0).round(2)
            elsif value_type == 'int'
                return @rand.rand(100000)
            elsif value_type == 'hash'
                return @rand.rand(999999999999)
            elsif value_type == 'small_int'
                # Int between 0 and 30,000
                # Want to keep this number fairly small so we
                # have more interesting queries
                return @rand.rand(30000)
            elsif value_type == 'id'
                return @rand.rand(100000)
            elsif value_type == 'address'
                return @rand.rand(99999)
            elsif value_type == 'name'
                return @name[@rand.rand(@name.length - 1)]
            elsif value_type == 'city'
                return @city[@rand.rand(@city.length - 1)]
            elsif value_type == 'phone_num'
                return @rand.rand(9999999999)
            elsif value_type == 'email'
                return @email[@rand.rand(@email.length - 1)]
            elsif value_type == 'country'
                return @country[@rand.rand(@country.length - 1)]
            elsif value_type == 'ip'
                return @ip[@rand.rand(@ip.length - 1)]
            elsif value_type == 'latitude'
                return @rand.rand(-90.0..90.0)
            elsif value_type == 'longitude'
                return @rand.rand(-180.0..180.0)
            elsif value_type == 'zip'
                return @rand.rand(99999)
            elsif value_type == 'credit_card_num'
                return @rand.rand(4999999999999999)
            elsif value_type == 'credit_card_type'
                return @cc[@rand.rand(@cc.length - 1)]
            elsif value_type == 'credit_card_expiry_date'
                return "#{@rand.rand(12)}" << "#{@rand.rand(31)}"
            elsif value_type == 'company'
                return @business[@rand.rand(@business.length - 1)]
            elsif value_type == 'date'
                # Random date in the past 90 days
                return Date.today - @rand.rand(365)
            elsif value_type == 'job_title'
                return @job[@rand.rand(@job.length - 1)]
            elsif value_type == 'time'
                # Uses 24 hour time and uses format hh:mm:ss
                hour = @rand.rand(24).to_s
                min = @rand.rand(59)
                if (min < 10)
                    min = min.to_s
                    min = "0"+min
                end
                sec = @rand.rand(59)
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

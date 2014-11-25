require 'json'
require 'rubygems'
require 'ruby-prof'
require 'date'
require 'time'

class Generator

    # Set which driver to use during random data generation and specifies lists of values that random data can be chosen from 
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
        @uuid = @rand.rand(10000)
        @bulk_doc_slug = 4000
    end

    # Set a specific driver to use
    def setDriver(driver)
        @driver = driver
    end

    # Call this function to generate random data. By default 1 document will be generated.
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

        file = File.read('flattened_manifest.json')
        @manifest = JSON.parse(file)
    end

    # Create a deep copy of the hash 
    def copyHash(hash)
        return Marshal.load(Marshal.dump(hash))
    end

    # Create objects until count is reached
    def createData(buffer, total_docs)

        puts "Starting generation for: #{@uuid}"

        # so we don't overallocate and break our array on test generations
        if @bulk_doc_slug > total_docs
            @bulk_doc_slug = total_docs
        end

        # average size of our output files
        doc_size = 3000.0

        # Ratio: Gigs/Hour
        dgh = doc_size * 3600.0 / 1000000000.0

        # tuning variables
        start_time = Time.now
        rounds = 0
        doc_count = 0
        while doc_count < total_docs do

            # Create an array to hold all of our generated documents for each
            # bulk upload
            obj = Array.new(@bulk_doc_slug * 2)
            bulk_count = 0

            while doc_count < total_docs && bulk_count < @bulk_doc_slug * 2 do

                #generate random inputs based on keys/values(types) provided from
                #manifest
                data_hash = {}
                @manifest.each do |key, val|
                    data_hash[key] = decomposeHash(val)
                end

                # Add an element to the array specifying we want to index, then add
                # the object to index.
                obj[bulk_count] = {index: { _index: :flat_transactions, _type: :item}}
                obj[bulk_count + 1] = {data: data_hash}

                # increment our counters
                doc_count += 1
                bulk_count += 2
            end

            begin
                # upload all the documents we generated in bulk
                if @driver.is_a?(Elastic)
                    @driver.bulk_load(obj)
                end
            rescue StandardError => error
                puts error
                doc_count = doc_count - @bulk_doc_slug
            end

            # Profiling, print every 10 cycles to keep concise
            if doc_count % @bulk_doc_slug * 10 == 0 || doc_count == total_docs then
                end_time = Time.now
                rounds += 10

                exec_time = end_time - start_time
                avg_time = exec_time.to_f / rounds
                exec_ratio = doc_count / exec_time
                gph = exec_ratio * dgh

                puts "#{@uuid}: T-#{avg_time} R-#{exec_ratio} GB/h-#{gph}"
            end

        end
        puts "Finished data generation!"
    end

    # Fills out each element of the hash with random data recursively
    # since our hash may contain nested hashes
    def decomposeHash(val)
        # If value is NOT a hash, change the value to random data appropriate to its type

        if !val.is_a?(Hash)
            return getRandom(val.to_sym)
        end

        # Decompose the hash into smaller components
        hash = {}
        val.each do |sub_key, sub_val|
            hash[sub_key] = decomposeHash(sub_val)
        end
        return hash

    end

    # Given the type of data needed, generates random data
    # Generates: float, int, string, address, name, city
    def getRandom(value_type)
        if value_type == :float
            # Takes any float between 0 and 10,000.00...
            # Rounds to 2 decimal places
            return @rand.rand(10000.0).round(2)
        elsif value_type == :int
            return @rand.rand(100000)
        elsif value_type == :hash
            return @rand.rand(999999999999)
        elsif value_type == :small_int
            # Int between 0 and 30,000
            # Want to keep this number fairly small so we
            # have more interesting queries
            return @rand.rand(30000)
        elsif value_type == :id
            return @rand.rand(100000)
        elsif value_type == :address
            return @rand.rand(99999)
        elsif value_type == :name
            return @name[@rand.rand(@name.length - 1)]
        elsif value_type == :city
            return @city[@rand.rand(@city.length - 1)]
        elsif value_type == :phone_num
            return @rand.rand(9999999999)
        elsif value_type == :email
            return @email[@rand.rand(@email.length - 1)]
        elsif value_type == :country
            return @country[@rand.rand(@country.length - 1)]
        elsif value_type == :ip
            return @ip[@rand.rand(@ip.length - 1)]
        elsif value_type == :latitude
            return @rand.rand(-90.0..90.0)
        elsif value_type == :longitude
            return @rand.rand(-180.0..180.0)
        elsif value_type == :zip
            return @rand.rand(99999)
        elsif value_type == :credit_card_num
            return @rand.rand(4999999999999999)
        elsif value_type == :credit_card_type
            return @cc[@rand.rand(@cc.length - 1)]
        elsif value_type == :credit_card_expiry_date
            return "#{@rand.rand(12)}" << "#{@rand.rand(31)}"
        elsif value_type == :company
            return @business[@rand.rand(@business.length - 1)]
        elsif value_type == :date
            # Random date in the past 90 days
            # 2014-Month-Day
            date = Date.today - @rand.rand(365)
            return date.to_s
        elsif value_type == :job_title
            return @job[@rand.rand(@job.length - 1)]
        elsif value_type == :time
            return Time.new - @rand.rand(3600)
        else
            puts "WTF: #{value_type}"
        end
    end
end

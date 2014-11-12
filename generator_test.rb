require_relative "generator"

# assertion documentation can be found here:
# http://www.rubydoc.info/gems/rspec-expectations/RSpec/Matchers
describe Generator, "getRandom" do
    it "should return proper values" do
        generator = Generator.new

        # str = generator.getRandom("string")
        # expect(str).to be_a_kind_of(String)
        # expect(str.length).to be < 0

        fl = generator.getRandom("float")
        expect(fl).to be_a_kind_of(Float)

        # int = generator.getRandom("int")
        # expect(str).to be_a_kind_of(Integer)

        # time = generator.getRandom("time")
        # expect(str).to be_a_kind_of(Time)

        # arr = generator.getRandom("array")
        # expect(str).to be_a_kind_of(Array)

        # hash = generator.getRandom("hash")
        # expect(str).to be_a_kind_of(Hash)
    end
end

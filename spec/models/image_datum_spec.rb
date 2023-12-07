# require 'rails_helper'

# DEFAULT_IMG_DESCRIPTION = "banana"

# RSpec.describe ImageDatum, type: :model do
#   describe "set_description" do
#     it "returns an existing description if available" do
#       id = ImageDatum.new(name: 'existing description', description: 'foo bar baz')
#       expect(id.description).to eq('foo bar baz')
#       id.set_description()
#       expect(id.description).to eq('foo bar baz')
#     end

#     it "pings an external API for a new description if one is not available" do
#       id = ImageDatum.new(name: 'no existing description')
#       initial_desc = id.description
#       expect(initial_desc).to eq(nil)
#       expect(id.description).to eq(initial_desc)
#       id.set_description()
#       expect(id.description).not_to eq(initial_desc)
#       expect(id.description).to eq(DEFAULT_IMG_DESCRIPTION)
#     end
#   end

#   # describe "new data" do
#   #   it "does not change the description if provided" do
#   #     words = "I am the provided description"
#   #     id = ImageDatum.new(name: 'description-provided', description: words)
#   #     expect(id.description).to eq(words)
#   #   end

#   #   it "sets the description if not provided" do
#   #     id = ImageDatum.new(name: 'Im a cool name')
#   #     expect(id.description).not_to eq(nil)
#   #     expect(id.description).to eq(DEFAULT_IMG_DESCRIPTION)
#   #   end
#   # end
# end

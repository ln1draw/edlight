include ActionDispatch::TestProcess

FactoryBot.define do
  factory :image_datum do
    image { Rack::Test::UploadedFile.new('spec/fixtures/images/example.png', 'image/png') }
  end
end

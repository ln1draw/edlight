require 'rails_helper'

DEFAULT_IMG_DESCRIPTION = "banana"

RSpec.describe 'ImageData', type: :request do
  describe 'POST /analyze_images' do
    # context 'with valid parameters' do
    #   let!(:test_data) { FactoryBot.create(:image_datum) }

    #   before do
    #     post '/analyze_images', params: {
    #         post: { image: test_data.image }
    #     }
    #   end

    #   it 'returns the description' do
    #     ret = JSON.parse response.body
    #     expect(ret['description']).to eq(DEFAULT_IMG_DESCRIPTION)
    #   end

    #   it 'returns a created status' do
    #     expect(response).to have_http_status(:created)
    #   end
    # end

    context 'with invalid parameters' do
        before do
            post '/analyze_images', params: {
                post: { image: '' }
            }
        end
        it 'returns a unprocessable entity status' do
            expect(response).to have_http_status(:unprocessable_entity)
        end
    end
  end
end
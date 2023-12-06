require "rails_helper"

RSpec.describe ImageDataController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/image_data").to route_to("image_data#index")
    end

    it "routes to #show" do
      expect(get: "/image_data/1").to route_to("image_data#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/image_data").to route_to("image_data#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/image_data/1").to route_to("image_data#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/image_data/1").to route_to("image_data#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/image_data/1").to route_to("image_data#destroy", id: "1")
    end
  end
end

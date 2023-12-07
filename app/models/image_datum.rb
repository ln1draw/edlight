class ImageDatum < ApplicationRecord
    mount_uploader :image, ImageUploader
    attr_accessor :description, :name

    def set_description(image_url)
        if @description.nil?
            @description = Querier.query(image_url)
        end
    end
end

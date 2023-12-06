class ImageDatum < ApplicationRecord
    mount_uploader :image, ImageUploader
    attr_accessor :description, :name

    def set_description
        if @description.nil?
            @description = Querier.query
        end
    end
end

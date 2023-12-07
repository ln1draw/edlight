class ImageDataController < ApplicationController

  # API endpoint
  # POST /analyze_images
  def analyze_images
    payload = "Bad Request: There was a problem with the data provided"
    status = 422

    id = ImageDatum.new(image_datum_params)
  
    # if the params save successfully
    if id.save && id.image.present?
      id.set_description(id.image.url)
      id.save

      # binding.pry
      # if the description exists after calling set_description
      if id.save && !id.description.nil?
        payload = id
        status = 201
      end
    end

    render json: payload, status: status
    
  end

  # GET /image_data
  def index
    @image_data = ImageDatum.all

    render json: @image_data
  end

  private
    # Only allow a list of trusted parameters through.
    def image_datum_params
      params.permit(:description, :name, :image)
    end
end

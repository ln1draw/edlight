class ImageDataController < ApplicationController
  before_action :set_image_datum, only: %i[ show update destroy ]

  # API endpoint
  def analyze_images

    id = ImageDatum.new(image_datum_params)

    if id.save
      render json: "hooray"
    else
      render json: 404
    end
    
  end

  # GET /image_data
  def index
    @image_data = ImageDatum.all

    render json: @image_data
  end

  # GET /image_data/1
  def show
    render json: @image_datum
  end

  # POST /image_data
  def create
    @image_datum = ImageDatum.new(image_datum_params)

    if @image_datum.save
      render json: @image_datum, status: :created, location: @image_datum
    else
      render json: @image_datum.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /image_data/1
  def update
    if @image_datum.update(image_datum_params)
      render json: @image_datum
    else
      render json: @image_datum.errors, status: :unprocessable_entity
    end
  end

  # DELETE /image_data/1
  def destroy
    @image_datum.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image_datum
      @image_datum = ImageDatum.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def image_datum_params
      params.permit(:description, :name, :image_datum, :image)
    end
end

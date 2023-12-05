class Api::V0::VendorsController < ApplicationController
  def index
    mrkt = Market.find_by(id: params[:market_id])
    if mrkt
      render json: VendorSerializer.new(mrkt.vendors)
    else
      render json: {errors: "Not Found"},
        status: :not_found,
        content_type: "application/json"
    end
  end

  def show
  end

  def create
  end

  def update
  end

  def destroy
  end
end

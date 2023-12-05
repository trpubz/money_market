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
    vndr = Vendor.find_by(id: params[:id])
    if vndr
      render json: VendorSerializer.new(vndr)
    else
      render json: {errors: "Not Found"},
        status: :not_found,
        content_type: "application/json"
    end
  end

  def create
  end

  def update
  end

  def destroy
  end

  def vendor_params
    params.require(:vendor).permit(
      :name,
      :description,
      :contact_name,
      :contact_phone,
      :credit_accepted
    )
  end
end

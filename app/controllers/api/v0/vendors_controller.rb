class Api::V0::VendorsController < ApplicationController
  def index
    mrkt = Market.find_by(id: params[:market_id])
    if mrkt
      render json: VendorSerializer.new(mrkt.vendors), status: :ok
    else
      render json: {errors: [{detail: "Not Found: bad id #{params[:market_id]}"}]},
        status: :not_found,
        content_type: "application/json"
    end
  end

  def show
    vndr = Vendor.find_by(id: params[:id])
    if vndr
      render json: VendorSerializer.new(vndr)
    else
      render json: {errors: [{detail: "Not Found: bad id #{params[:id]}"}]},
        status: :not_found,
        content_type: "application/json"
    end
  end

  def create
    vndr = Vendor.create(vendor_params)
    if vndr.valid?
      render json: VendorSerializer.new(vndr), status: :created
    else
      render json: {errors: vndr.errors.full_messages.map { |msg| {detail: "Validation failed: #{msg}"} }}, status: :bad_request
    end
  end

  def update
    vndr = Vendor.find_by(id: params[:id])
    if vndr
      vndr.update(vendor_params)
      if !vndr.valid?
        render json: {errors: vndr.errors.full_messages.map { |msg| "Validation failed: #{msg}" }},
          status: :bad_request
      else
        render json: VendorSerializer.new(vndr), status: :ok
      end
    else
      render json: {errors: [{detail: "Couldn't find Vendor with 'id'=#{params[:id]}"}]}, status: :not_found
    end
  end

  def destroy
    vndr = Vendor.find_by(id: params[:id])
    if vndr
      vndr.destroy!
      render json: {}, status: :no_content
    else
      render json: {errors: [{detail: "Couldn't find Vendor with 'id'=#{params[:id]}"}]}, status: :not_found
    end
  end

  def vendor_params
    params.permit(
      :name,
      :description,
      :contact_name,
      :contact_phone,
      :credit_accepted
    )
  end
end

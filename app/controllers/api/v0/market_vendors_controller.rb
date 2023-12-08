class Api::V0::MarketVendorsController < ApplicationController
  def create
    p = market_vendor_params
    if p[:market_id].to_s.empty? || p[:vendor_id].to_s.empty?
      render json: {errors: "id values cannot be empty"}, status: :bad_request
    else
      mrkt_vndr = MarketVendor.create(p)
      if mrkt_vndr.valid?
        render json: {message: "Successfully added vendor to market"}, status: :created
      elsif mrkt_vndr.errors.first.type == :taken
        render json: {errors: mrkt_vndr.errors.full_messages.map { |msg| "Validation failed: #{msg}" }},
          status: :unprocessable_entity
      else
        render json: {errors: mrkt_vndr.errors.full_messages.map { |msg| "Validation failed: #{msg}" }},
          status: :not_found
      end
    end
  end

  def destroy
    p = market_vendor_params
    mrkt_vndr = MarketVendor.find_by(p)

    if mrkt_vndr
      mrkt_vndr.destroy!
      render json: {}, status: :no_content
    else
      raise ActiveRecord::RecordNotFound, "No MarketVendor for #{p}"
      # render json: {errors: "No MarketVendor for #{p.to_s}"}, status: :not_found
    end
  end

  private

  def market_vendor_params
    params.permit(:market_id, :vendor_id)
  end
end

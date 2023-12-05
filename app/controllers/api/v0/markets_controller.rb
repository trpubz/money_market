class Api::V0::MarketsController < ApplicationController
  def index
    render json: Market.all
  end

  def show
    mrkt = Market.find_by(id: params[:id])  # must use #find_by here because #find will return early with rails default error

    if mrkt
      render json: mrkt
    else
      render json: {error: "Market #{params[:id]} not found"}, status: :not_found, content_type: "application/json"
    end
  end

  def create
    render json: Market.create(market_params)
  end

  def update
    render json: Market.update(params[:id], market_params)
  end

  def destroy
    render json: Market.delete(params[:id])
  end

  private

  def market_params
    params.require(:market).permit(
      :name,
      :street,
      :city,
      :county,
      :state,
      :zip,
      :lat,
      :lon,
      :vendor_count
    )
  end
end

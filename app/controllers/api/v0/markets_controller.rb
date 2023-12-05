class Api::V0::MarketsController < ApplicationController
  def index
    render json: Market.all
  end

  def show
    render json: Market.find(params[:id])
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

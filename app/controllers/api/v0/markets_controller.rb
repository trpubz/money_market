require_relative "../../../facades/atm_facade"
require_relative "../../../serializers/atm_serializer"

class Api::V0::MarketsController < ApplicationController
  def index
    markets = Market.all
    render json: {
      data: markets.map do |market|
        {
          type: "market",
          attributes: MarketSerializer.format_market(market)
        }
      end
    }
  end

  def show
    mrkt = Market.find_by(id: params[:id])  # must use #find_by here because #find will return early with rails default error

    if mrkt
      render json: {
        data: {
          type: "market",
          id: params[:id],
          attributes: MarketSerializer.format_market(mrkt).except(:id)
        }
      }
    else
      render json: {errors: "Not Found"},
        status: :not_found,
        content_type: "application/json"
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

  def search
    if valid_param_combo?
      mrkts = Market.search(search_params)
      render json: MarketSerializer.new(mrkts), status: :ok
    else
      render json: {errors: "Invalid set of parameters."}, status: :unprocessable_entity
    end
  end

  def nearest_atms
    mrkt = Market.find_by(id: params[:id])
    if mrkt
      render json: ATMSerializer.new(ATMFacade.atms(mrkt))
    else
      render json: {errors: "Not Found"}, status: :not_found
    end
  end

  private

  def valid_param_combo?
    validator = search_params.to_h

    validator.each do |key, _|  # param is [k,v] array
      if key == "city"
        validator.delete(:city)
        validator.delete(:name) if validator.has_key?(:name)
      end
    end

    validator.count > 0
  end

  def search_params
    params.permit(:state,
      :city,
      :name)
  end

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

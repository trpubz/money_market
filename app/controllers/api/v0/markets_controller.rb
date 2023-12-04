class Api::V0::MarketsController < ApplicationController
  def index
    render json: Market.all
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

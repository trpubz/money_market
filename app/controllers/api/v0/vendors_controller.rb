class Api::V0::VendorsController < ApplicationController
  def index
    render json: Vendor.all
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

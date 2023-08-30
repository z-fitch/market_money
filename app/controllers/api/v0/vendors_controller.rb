class Api::V0::VendorsController < ApplicationController
  def index
    begin
      render json: VendorSerializer.new(Market.find(params[:market_id]).vendors)
    rescue ActiveRecord::RecordNotFound => error
      render json: ErrorMemberSerializer.new(error).not_found_errors, status: :not_found
    end
  end

  def show 
    begin
      render json: VendorSerializer.new(Vendor.find(params[:id]))
    rescue ActiveRecord::RecordNotFound => error
      render json: ErrorMemberSerializer.new(error).not_found_errors, status: :not_found
    end
  end

  def create

  end
end
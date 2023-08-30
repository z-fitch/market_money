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
    begin
      render json: VendorSerializer.new(Vendor.create!(vendor_params)), status: :created
    rescue ActiveRecord::RecordInvalid => error
      render json: ErrorMemberSerializer.new(error).not_found_errors, status: :bad_request
    end
  end

  def update
    begin
      render json: VendorSerializer.new(Vendor.update!(params[:id], vendor_params)), status: :accepted
    rescue ActiveRecord::RecordInvalid => error
      render json: ErrorMemberSerializer.new(error).not_found_errors, status: :bad_request
    rescue ActiveRecord::RecordNotFound => error
      render json: ErrorMemberSerializer.new(error).not_found_errors, status: :not_acceptable
    end
  end

  private

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_phone, :contact_name, :credit_accepted)
  end
end
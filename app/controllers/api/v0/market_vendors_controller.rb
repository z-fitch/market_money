class Api::V0::MarketVendorsController < ApplicationController
  def create
    begin
      render json: MarketVendor.create!(mv_params), status: 201
    rescue ActiveRecord::RecordInvalid => error
      if params[:market_vendor][:market_id]  == "" || nil
        render json: ErrorMemberSerializer.new(error).not_found_errors, status: 400
      elsif params[:market_vendor][:vendor_id]  == "" || nil
        render json: ErrorMemberSerializer.new(error).not_found_errors, status: 400
      else
        render json: ErrorMemberSerializer.new(error).not_found_errors, status: 404
      end
    rescue ActiveRecord::StatementInvalid => error
      render json: ErrorMemberSerializer.new(error).not_found_errors, status: 422
    end
  end

  def destroy
    if MarketVendor.find_by(market_id: params[:market_id], vendor_id: params[:vendor_id]).nil?
      render json: ErrorMemberSerializer.new([params[:market_id], params[:vendor_id]]).no_assoociation_error, status: :not_found
    else
      render json: MarketVendor.delete(MarketVendor.find_by(market_id: params[:market_id], vendor_id: params[:vendor_id])), status: :no_content
    end
  end

  private

  def mv_params
    params.require(:market_vendor).permit(:market_id, :vendor_id)

  end
end
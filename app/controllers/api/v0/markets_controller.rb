class Api::V0::MarketsController < ApplicationController
  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    begin
      render json: MarketSerializer.new(Market.find(params[:id]))
    rescue ActiveRecord::RecordNotFound => error
      render json: ErrorSerializer.new(error).format_errors, status: :not_found
    end
  end

  def search
    begin
      render json: MarketSerializer.new(Market.search(params)), status: 200
    rescue ActiveRecord::RecordNotFound => error
      render json: ErrorSerializer.new(error).format_errors, status: 422
    end
  end

  def get_atms
    begin
      market = Market.find(params[:id])

      response = Faraday.get("https://api.tomtom.com/search/2/nearbySearch/.json?key=#{ENV['TOM_TOM_API']}&lat=#{market[:lat]}&lon=#{market[:lon]}&categorySet=7397")
      data = JSON.parse(response.body)
      
      render json: AtmSerializer.new(data).format_api, status: 200
    rescue ActiveRecord::RecordNotFound => error
      render json: ErrorSerializer.new(error).format_errors, status: 404
    end
  end
end

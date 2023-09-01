class MarketAtmFacade
  attr_reader :market, :service
  
  def initialize(data)
    # require 'pry'; binding.pry
    @market = data
    @service = AtmService.new
  end

  def movie_details
    json = @service.atm(@market)
    VendorSerializer.new(json)
  end
end
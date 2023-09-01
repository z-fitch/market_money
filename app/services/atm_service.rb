class AtmService

  def atm(market)
    # require 'pry'; binding.pry
    get_url("&lat=#{market[:lat]}&lon=#{market[:lon]}&categorySet=7397")
  end


  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def conn
    Faraday.new(url: "https://api.tomtom.com/search/2/nearbySearch/.json?") do |faraday|
      faraday.params['key'] = ENV['TOM_TOM_API']
    end
  end
end
class AtmSerializer
  include JSONAPI::Serializer

  def initialize(api)
    # require 'pry'; binding.pry
    @api =api
  end

  def format_api
      {
        "data": @api["results"].map do |atm|
            {
                "id": 'null',
                "type": "atm",
                "attributes": {
                    "name": "ATM",
                    "address": atm["address"]["freeformAddress"],
                    "lat": atm["position"]["lat"],
                    "lon": atm["position"]["lon"],
                    "distance": atm["dist"]
                }
            }
          end
      }
  end
end
require 'rails_helper'

describe 'Markets' do
  describe 'get all' do 
    it 'sends a list of all markets' do
      create_list(:market, 3)

      get '/api/v0/markets'

      expect(response).to be_successful

      markets = JSON.parse(response.body, symbolize_names: true)

      expect(markets[:data].count).to eq(3)

      markets[:data].each do |market|
        expect(market).to have_key(:id)
        expect(market[:id]).to be_a(String)

        expect(market).to have_key(:type)
        expect(market[:type]).to be_a(String)

        expect(market[:attributes]).to have_key(:name)
        expect(market[:attributes][:name]).to be_a(String)

        expect(market[:attributes]).to have_key(:street)
        expect(market[:attributes][:street]).to be_a(String)

        expect(market[:attributes]).to have_key(:city)
        expect(market[:attributes][:city]).to be_a(String)

        expect(market[:attributes]).to have_key(:county)
        expect(market[:attributes][:county]).to be_a(String)
        
        expect(market[:attributes]).to have_key(:state)
        expect(market[:attributes][:state]).to be_a(String)

        expect(market[:attributes]).to have_key(:zip)
        expect(market[:attributes][:zip]).to be_a(String)

        expect(market[:attributes]).to have_key(:lat)
        expect(market[:attributes][:lat]).to be_a(String)

        expect(market[:attributes]).to have_key(:lon)
        expect(market[:attributes][:lon]).to be_a(String)

        expect(market[:attributes]).to have_key(:vendor_count)
        expect(market[:attributes][:vendor_count]).to be_a(Integer)
      end
    end
  end

  describe 'get a specific market' do 
    it 'sends a specific market and succeeds ' do 
      market_1 = create(:market)

      get "/api/v0/markets/#{market_1.id}"

      expect(response).to be_successful

      market = JSON.parse(response.body, symbolize_names: true)

      expect(market[:data]).to have_key(:id)
      expect(market[:data][:id]).to be_a(String)

      expect(market[:data]).to have_key(:type)
      expect(market[:data][:type]).to be_a(String)

      expect(market[:data][:attributes]).to have_key(:name)
      expect(market[:data][:attributes][:name]).to be_a(String)

      expect(market[:data][:attributes]).to have_key(:street)
      expect(market[:data][:attributes][:street]).to be_a(String)

      expect(market[:data][:attributes]).to have_key(:city)
      expect(market[:data][:attributes][:city]).to be_a(String)

      expect(market[:data][:attributes]).to have_key(:county)
      expect(market[:data][:attributes][:county]).to be_a(String)
      
      expect(market[:data][:attributes]).to have_key(:state)
      expect(market[:data][:attributes][:state]).to be_a(String)

      expect(market[:data][:attributes]).to have_key(:zip)
      expect(market[:data][:attributes][:zip]).to be_a(String)

      expect(market[:data][:attributes]).to have_key(:lat)
      expect(market[:data][:attributes][:lat]).to be_a(String)

      expect(market[:data][:attributes]).to have_key(:lon)
      expect(market[:data][:attributes][:lon]).to be_a(String)

      expect(market[:data][:attributes]).to have_key(:vendor_count)
      expect(market[:data][:attributes][:vendor_count]).to be_a(Integer)
    end

    it 'sends a specific market and fails ' do 
      id = 12343234

      get "/api/v0/markets/#{id}"

      error_message = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to have_http_status(404)
      
      expect(error_message).to have_key(:errors)
      expect(error_message[:errors]).to be_a(Array)

      expect(error_message[:errors].first).to have_key(:detail)
      expect(error_message[:errors].first[:detail]).to be_a(String)

      expect(error_message[:errors].first[:detail]).to eq("Couldn't find Market with 'id'=#{id}")
    end
  end

  describe 'get all the vendors for a single market' do 
    it 'sends a specific market and gets all the vendors and succeeds' do 
      market_1 = create(:market)
      vendor_1 = create(:vendor)
      vendor_2 = create(:vendor)
      vendor_3 = create(:vendor)

      MarketVendor.create!(market_id: market_1.id, vendor_id: vendor_1.id)
      MarketVendor.create!(market_id: market_1.id, vendor_id: vendor_2.id)
      MarketVendor.create!(market_id: market_1.id, vendor_id: vendor_3.id)

      get "/api/v0/markets/#{market_1.id}/vendors"

      expect(response).to be_successful

      vendors = JSON.parse(response.body, symbolize_names: true)

      expect(vendors[:data].count).to eq(3)

      vendors[:data].each do |vendor|
        expect(vendor).to have_key(:id)
        expect(vendor[:id]).to be_a(String)

        expect(vendor).to have_key(:type)
        expect(vendor[:type]).to be_a(String)

        expect(vendor[:attributes]).to have_key(:name)
        expect(vendor[:attributes][:name]).to be_a(String)

        expect(vendor[:attributes]).to have_key(:description)
        expect(vendor[:attributes][:description]).to be_a(String)

        expect(vendor[:attributes]).to have_key(:contact_name)
        expect(vendor[:attributes][:contact_name]).to be_a(String)

        expect(vendor[:attributes]).to have_key(:contact_phone)
        expect(vendor[:attributes][:contact_phone]).to be_a(String)

        expect(vendor[:attributes]).to have_key(:credit_accepted)
        expect(vendor[:attributes][:credit_accepted]).to be_in([true, false])
      end
    end

    it 'sends a specific market and fails ' do 
      bad_id = 123123123123

      get "/api/v0/markets/#{bad_id}/vendors"

      error_message = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to have_http_status(404)
      
      expect(error_message).to have_key(:errors)
      expect(error_message[:errors]).to be_a(Array)

      expect(error_message[:errors].first).to have_key(:detail)
      expect(error_message[:errors].first[:detail]).to be_a(String)

      expect(error_message[:errors].first[:detail]).to eq("Couldn't find Market with 'id'=#{bad_id}")
    end
  end

  describe 'search for a market' do 
    it 'can successfully search for a market(city and state)' do 
      create(:market, state: 'texas', city: 'dallas')
      create_list(:market, 2 , state: 'utah', city: 'salt lake')

      get "/api/v0/markets/search?state=texas&city=dallas"

      expect(response).to be_successful
      expect(response).to have_http_status(200)
      searched_markets = JSON.parse(response.body, symbolize_names: true)

      first_market = searched_markets[:data].first

      expect(searched_markets[:data].count).to eq(1)
      expect(searched_markets[:data].count).to_not eq(3)

      expect(first_market[:attributes][:state]).to eq('texas')
      expect(first_market[:attributes][:city]).to eq('dallas')
    end

    it 'can successfully search for a market with only a state param' do 
      create_list(:market, 3 , state: 'texas')
      create_list(:market, 2 , state: 'utah')

      get "/api/v0/markets/search?state=texas"

      expect(response).to be_successful
      expect(response).to have_http_status(200)
      searched_markets = JSON.parse(response.body, symbolize_names: true)

      first_market = searched_markets[:data].first

      expect(searched_markets[:data].count).to eq(3)
      expect(searched_markets[:data].count).to_not eq(5)

      expect(first_market[:attributes][:state]).to eq('texas')
    end

    it 'can successfully search for a market with state, city, and name params' do 
      create(:market, state: "texas", city: "dallas", name: "Cool market")
      create(:market, state: 'texas', city: 'dallas', name: 'That Other Market')

      create_list(:market, 2 , state: 'utah')

      get "/api/v0/markets/search?state=texas&city=dallas&name=cool market"

      expect(response).to be_successful
      expect(response).to have_http_status(200)
      searched_markets = JSON.parse(response.body, symbolize_names: true)

      first_market = searched_markets[:data].first

      expect(searched_markets[:data].count).to eq(1)
      expect(searched_markets[:data].count).to_not eq(5)

      expect(first_market[:attributes][:state]).to eq('texas')
      expect(first_market[:attributes][:city]).to eq('dallas')
      expect(first_market[:attributes][:name]).to eq('Cool market')
    end

    it 'can successfully search for a market with state, and name params' do 
      create(:market, state: "texas", city: "dallas", name: "Cool market")
      create(:market, state: 'texas', city: 'dallas', name: 'That Other Market')

      create_list(:market, 2 , state: 'utah')

      get "/api/v0/markets/search?state=texas&name=cool market"

      expect(response).to be_successful
      expect(response).to have_http_status(200)
      searched_markets = JSON.parse(response.body, symbolize_names: true)

      first_market = searched_markets[:data].first

      expect(searched_markets[:data].count).to eq(1)
      expect(searched_markets[:data].count).to_not eq(5)

      expect(first_market[:attributes][:state]).to eq('texas')
      expect(first_market[:attributes][:name]).to eq('Cool market')
    end

    it 'can successfully search for a market with name params' do 
      create(:market, state: "texas", city: "dallas", name: "Cool market")
      create(:market, state: 'texas', city: 'dallas', name: 'That Other Market')

      create_list(:market, 2 , state: 'utah')

      get "/api/v0/markets/search?name=Cool market"

      expect(response).to be_successful
      expect(response).to have_http_status(200)
      searched_markets = JSON.parse(response.body, symbolize_names: true)

      first_market = searched_markets[:data].first

      expect(searched_markets[:data].count).to eq(1)
      expect(searched_markets[:data].count).to_not eq(5)

      expect(first_market[:attributes][:name]).to eq('Cool market')
    end

    it 'can successfully search for a market with no params(returns [])' do 
      create(:market, state: "texas", city: "dallas", name: "Cool market")
      create(:market, state: 'texas', city: 'dallas', name: 'That Other Market')

      create_list(:market, 2 , state: 'utah')

      get "/api/v0/markets/search?state=nevada"

      expect(response).to be_successful
      expect(response).to have_http_status(200)
      searched_markets = JSON.parse(response.body, symbolize_names: true)


      expect(searched_markets[:data]).to eq([])
    end

    it 'can Unsuccessfully search for a market with city params' do 
      create(:market, state: "texas", city: "dallas", name: "Cool market")
      create(:market, state: 'texas', city: 'dallas', name: 'That Other Market')

      create_list(:market, 2 , state: 'utah')

      get "/api/v0/markets/search?city=dallas"

      error_message = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to have_http_status(422)

      expect(error_message).to have_key(:errors)
      expect(error_message[:errors]).to be_a(Array)
      
      expect(error_message[:errors].first).to have_key(:detail)
      expect(error_message[:errors].first[:detail]).to be_a(String)

      expect(error_message[:errors].first[:detail]).to eq("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.")
    end

    it 'can Unsuccessfully search for a market with city and name params' do 
      create(:market, state: "texas", city: "dallas", name: "Cool market")
      create(:market, state: 'texas', city: 'dallas', name: 'That Other Market')

      create_list(:market, 2 , state: 'utah')

      get "/api/v0/markets/search?city=dallas&name=cool market"

      error_message = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to have_http_status(422)

      expect(error_message).to have_key(:errors)
      expect(error_message[:errors]).to be_a(Array)
      
      expect(error_message[:errors].first).to have_key(:detail)
      expect(error_message[:errors].first[:detail]).to be_a(String)

      expect(error_message[:errors].first[:detail]).to eq("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.")
    end
  end

  describe 'getting the nearest ATMS' do 
    it 'can get the nearest ATMS', :vcr do 
      market_1 = create(:market, state: "texas", city: "dallas", name: "Cool market", lat: '32.779167', lon: '-96.808891')

      get "/api/v0/markets/#{market_1.id}/nearest_atms"

      expect(response).to be_successful
      expect(response).to have_http_status(200)

      atms = JSON.parse(response.body, symbolize_names: true)

      first_atm = atms[:data].first

      expect(atms[:data].count).to eq(10)

      
      expect(first_atm[:attributes][:name]).to eq('ATM')
      expect(first_atm[:attributes][:address]).to eq('411 Elm Street, Dallas, TX 75202')
      expect(first_atm[:attributes][:lat]).to eq(32.779637)
      expect(first_atm[:attributes][:lon]).to eq(-96.808381)
      expect(first_atm[:attributes][:distance]).to eq(70.702651)
    end

    it 'cant get the nearest ATMS if the market doesnt exist', :vcr do 
      market_1 = 1234123412341234

      get "/api/v0/markets/#{market_1}/nearest_atms"

      error_message = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to have_http_status(404)

      expect(error_message).to have_key(:errors)
      expect(error_message[:errors]).to be_a(Array)
      
      expect(error_message[:errors].first).to have_key(:detail)
      expect(error_message[:errors].first[:detail]).to be_a(String)

      expect(error_message[:errors].first[:detail]).to eq("Couldn't find Market with 'id'=1234123412341234")
    end
  end
end
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
end
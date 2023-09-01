require 'rails_helper'

describe 'MarketVendors' do
  describe 'Create a Market Vendor succesfully' do 
    it 'can create a market vendor' do 
      market_1 = create(:market)
      vendor_1 = create(:vendor)

      mv_params = ({
        market_id: market_1.id,
        vendor_id: vendor_1.id
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: mv_params)
      created_mv = MarketVendor.last

      expect(response).to be_successful
      expect(response).to have_http_status(201)

      expect(created_mv.market_id).to eq(mv_params[:market_id])
      expect(created_mv.vendor_id).to eq(mv_params[:vendor_id])
      
      expect(market_1.vendors.count).to eq(1)
      expect(market_1.vendors).to match_array(vendor_1)
    end
  end

  describe 'Create a Market Vendor Unsuccesfully' do 
    it 'cant create a market vendor if an invaild market was passed in' do 
      market_1 = '23412341234123'
      vendor_1 = create(:vendor)

      mv_params = ({
        market_id: market_1,
        vendor_id: vendor_1.id
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: mv_params)
      error_message = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(404)

      expect(error_message).to have_key(:errors)
      expect(error_message[:errors]).to be_a(Array)
      
      expect(error_message[:errors].first).to have_key(:detail)
      expect(error_message[:errors].first[:detail]).to be_a(String)

      expect(error_message[:errors].first[:detail]).to eq("Validation failed: Market must exist")
    end

    it 'cant create a market vendor if an invaild vendor was passed in' do 
      market_1 = create(:market)
      vendor_1 = '23412341234123'

      mv_params = ({
        market_id: market_1.id,
        vendor_id: vendor_1
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: mv_params)
      error_message = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(404)

      expect(error_message).to have_key(:errors)
      expect(error_message[:errors]).to be_a(Array)
      
      expect(error_message[:errors].first).to have_key(:detail)
      expect(error_message[:errors].first[:detail]).to be_a(String)

      expect(error_message[:errors].first[:detail]).to eq("Validation failed: Vendor must exist")
    end

    it 'cant create a market vendor if its missing a market param' do 
      vendor_1 = create(:vendor)

      mv_params = ({
        market_id: '',
        vendor_id: vendor_1.id
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: mv_params)
      error_message = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(400)

      expect(error_message).to have_key(:errors)
      expect(error_message[:errors]).to be_a(Array)
      
      expect(error_message[:errors].first).to have_key(:detail)
      expect(error_message[:errors].first[:detail]).to be_a(String)

      expect(error_message[:errors].first[:detail]).to eq("Validation failed: Market must exist, Market can't be blank")
    end

    it 'cant create a market vendor if its missing a vender param' do 
      market_1 = create(:market)

      mv_params = ({
        market_id: market_1.id,
        vendor_id: ''
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: mv_params)
      error_message = JSON.parse(response.body, symbolize_names: true)
      expect(response).to_not be_successful
      expect(response).to have_http_status(400)

      expect(error_message).to have_key(:errors)
      expect(error_message[:errors]).to be_a(Array)
      
      expect(error_message[:errors].first).to have_key(:detail)
      expect(error_message[:errors].first[:detail]).to be_a(String)

      expect(error_message[:errors].first[:detail]).to eq("Validation failed: Vendor must exist, Vendor can't be blank")
    end

    it 'cant create a market vendor if its already exists' do 
      market_1 = create(:market)
      vendor_1 = create(:vendor)

      mv_params = ({
        market_id: market_1.id,
        vendor_id: vendor_1.id
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: mv_params)
      
      expect(response).to have_http_status(201)


      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: mv_params)

      expect(response).to have_http_status(422)

      error_message = JSON.parse(response.body, symbolize_names: true)

      expect(error_message).to have_key(:errors)
      expect(error_message[:errors]).to be_a(Array)
      
      expect(error_message[:errors].first).to have_key(:detail)
      expect(error_message[:errors].first[:detail]).to be_a(String)

      expect(error_message[:errors].first[:detail]).to eq("Validation failed: Market vendor asociation between market with market_id=#{market_1.id} and vendor_id=#{vendor_1.id} already exists")
    end
  end

  describe 'delete a market_vendor association' do 
    it 'can successfully delete a market vendor' do
      market_1 = create(:market)
      vendor_1 = create(:vendor)

      mv_params = ({
        market_id: market_1.id,
        vendor_id: vendor_1.id
      })

      mv_1 = MarketVendor.create!(mv_params)
      
      delete "/api/v0/market_vendors", headers: headers, params: mv_params
      expect(response).to be_successful
      expect(response).to have_http_status(204)

      expect(MarketVendor.count).to eq(0)
      expect{MarketVendor.find(mv_1.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'can Unsuccessfully try to delete a market vendor' do
      market_1 = create(:market)
      vendor_1 = create(:vendor)

      mv_params = ({
        market_id: market_1.id,
        vendor_id: vendor_1.id
      })

      delete "/api/v0/market_vendors", headers: headers, params: mv_params

      expect(response).to have_http_status(404)

      expect(MarketVendor.count).to eq(0)
      
      error_message = JSON.parse(response.body, symbolize_names: true)
      
      expect(error_message[:errors].first[:detail]).to eq("No MarketVendor with market_id=#{market_1.id} AND vendor_id=#{vendor_1.id} exists")
    end
  end
end
require 'rails_helper'

describe 'Vendors' do
  describe 'get one Vendor' do 
    it 'gets a single vendor with a success' do
      vendor_1 = create(:vendor)

      get "/api/v0/vendors/#{vendor_1.id}"

      expect(response).to be_successful

      vendor = JSON.parse(response.body, symbolize_names: true)

      expect(vendor[:data]).to have_key(:id)
      expect(vendor[:data][:id]).to be_a(String)

      expect(vendor[:data]).to have_key(:type)
      expect(vendor[:data][:type]).to be_a(String)

      expect(vendor[:data][:attributes]).to have_key(:name)
      expect(vendor[:data][:attributes][:name]).to be_a(String)

      expect(vendor[:data][:attributes]).to have_key(:description)
      expect(vendor[:data][:attributes][:description]).to be_a(String)

      expect(vendor[:data][:attributes]).to have_key(:contact_name)
      expect(vendor[:data][:attributes][:contact_name]).to be_a(String)

      expect(vendor[:data][:attributes]).to have_key(:contact_phone)
      expect(vendor[:data][:attributes][:contact_phone]).to be_a(String)

      expect(vendor[:data][:attributes]).to have_key(:credit_accepted)
      expect(vendor[:data][:attributes][:credit_accepted]).to be_in([true, false])
    end

    it 'sends a specific vendors and fails ' do 
      id = 12343234

      get "/api/v0/vendors/#{id}"

      error_message = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to have_http_status(404)
      
      expect(error_message).to have_key(:errors)
      expect(error_message[:errors]).to be_a(Array)

      expect(error_message[:errors].first).to have_key(:detail)
      expect(error_message[:errors].first[:detail]).to be_a(String)

      expect(error_message[:errors].first[:detail]).to eq("Couldn't find Vendor with 'id'=#{id}")
    end
  end

  describe 'Create a vendor' do 
    it 'can create a vendor successfully' do 
      vendor_params = ({
                      name: 'Some Random Name',
                      description: 'Sells non discript things',
                      contact_name: 'John Doe',
                      contact_phone: '576-349-3943',
                      credit_accepted: true
                    })
      headers = {"CONTENT_TYPE" => "application/json"}
    
      post "/api/v1/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
      created_vendor = Vendor.last
    
      expect(response).to be_successful
      expect(created_vendor.name).to eq(vendor_params[:name])
      expect(created_vendor.description).to eq(vendor_params[:description])
      expect(created_vendor.contact_phone).to eq(vendor_params[:contact_phone])
      expect(created_vendor.contact_name).to eq(vendor_params[:contact_name])
      expect(created_vendor.credit_accepted).to eq(vendor_params[:credit_accepted])
    end
  end
end
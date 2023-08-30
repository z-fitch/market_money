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
    
      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
      created_vendor = Vendor.last
    
      expect(response).to be_successful
      expect(response).to have_http_status(201)

      expect(created_vendor.name).to eq(vendor_params[:name])
      expect(created_vendor.description).to eq(vendor_params[:description])
      expect(created_vendor.contact_phone).to eq(vendor_params[:contact_phone])
      expect(created_vendor.contact_name).to eq(vendor_params[:contact_name])
      expect(created_vendor.credit_accepted).to eq(vendor_params[:credit_accepted])
    end

    it 'cant created a vendor if name is blank' do 
      vendor_params = ({
        name: '',
        description: 'Sells non discript things',
        contact_name: 'John Doe',
        contact_phone: '576-349-3943',
        credit_accepted: true
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
      error_message = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to have_http_status(400)

      expect(error_message).to have_key(:errors)
      expect(error_message[:errors]).to be_a(Array)
      
      expect(error_message[:errors].first).to have_key(:detail)
      expect(error_message[:errors].first[:detail]).to be_a(String)

      expect(error_message[:errors].first[:detail]).to eq("Validation failed: Name can't be blank")
    end

    it 'cant created a vendor if description is blank' do 
      vendor_params = ({
        name: 'Some Random Name',
        description: '',
        contact_name: 'John Doe',
        contact_phone: '576-349-3943',
        credit_accepted: true
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
      error_message = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to have_http_status(400)

      expect(error_message).to have_key(:errors)
      expect(error_message[:errors]).to be_a(Array)
      
      expect(error_message[:errors].first).to have_key(:detail)
      expect(error_message[:errors].first[:detail]).to be_a(String)

      expect(error_message[:errors].first[:detail]).to eq("Validation failed: Description can't be blank")
    end

    it 'cant created a vendor if contact_name is blank' do 
      vendor_params = ({
        name: 'Some Random Name',
        description: 'Sells Some Things',
        contact_name: '',
        contact_phone: '576-349-3943',
        credit_accepted: true
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
      error_message = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to have_http_status(400)

      expect(error_message).to have_key(:errors)
      expect(error_message[:errors]).to be_a(Array)
      
      expect(error_message[:errors].first).to have_key(:detail)
      expect(error_message[:errors].first[:detail]).to be_a(String)

      expect(error_message[:errors].first[:detail]).to eq("Validation failed: Contact name can't be blank")
    end

    it 'cant created a vendor if contact phone is blank' do 
      vendor_params = ({
        name: 'Some Random Name',
        description: 'Sells Some Things',
        contact_name: 'A really cool name',
        contact_phone: '',
        credit_accepted: true
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
      error_message = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to have_http_status(400)

      expect(error_message).to have_key(:errors)
      expect(error_message[:errors]).to be_a(Array)
      
      expect(error_message[:errors].first).to have_key(:detail)
      expect(error_message[:errors].first[:detail]).to be_a(String)

      expect(error_message[:errors].first[:detail]).to eq("Validation failed: Contact phone can't be blank")
    end

    it 'cant created a vendor if credit_accepted is nil' do 
      vendor_params = ({
        name: 'Some Random Name',
        description: 'Sells Some Things',
        contact_name: 'A really cool name',
        contact_phone: '234-234-2345',
        credit_accepted: nil
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
      error_message = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to have_http_status(400)

      expect(error_message).to have_key(:errors)
      expect(error_message[:errors]).to be_a(Array)
      
      expect(error_message[:errors].first).to have_key(:detail)
      expect(error_message[:errors].first[:detail]).to be_a(String)

      expect(error_message[:errors].first[:detail]).to eq("Validation failed: Credit accepted must be a Boolean")
    end

    it 'cant created a vendor if credit_accepted is blank' do 
      vendor_params = ({
        name: 'Some Random Name',
        description: 'Sells Some Things',
        contact_name: 'A really cool name',
        contact_phone: '234-234-2345',
        credit_accepted: ''
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
      error_message = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to have_http_status(400)

      expect(error_message).to have_key(:errors)
      expect(error_message[:errors]).to be_a(Array)
      
      expect(error_message[:errors].first).to have_key(:detail)
      expect(error_message[:errors].first[:detail]).to be_a(String)

      expect(error_message[:errors].first[:detail]).to eq("Validation failed: Credit accepted must be a Boolean")
    end
  end

  describe 'Update a vendor' do 
    describe 'can successfully update a vendor' do 
      it "can update an existing vendors name" do
        id = create(:vendor).id
        previous_name = Vendor.last.name
        vendor_params = { name: "A way COOLER name" }
        headers = {"CONTENT_TYPE" => "application/json"}
      
        patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate({vendor: vendor_params})
        vendor_1 = Vendor.find_by(id: id)
      
        expect(response).to be_successful
        expect(vendor_1.name).to_not eq(previous_name)
        expect(vendor_1.name).to eq("A way COOLER name")
      end

      it "can update an existing vendors description, contact_name, contact_phone" do
        id = create(:vendor).id
        previous_description = Vendor.last.description
        previous_contact_name = Vendor.last.contact_name
        previous_contact_phone = Vendor.last.contact_phone

        vendor_params = { description: "I sell some really cool things", contact_name: "Mr. Cool", contact_phone: "123-345-4567", credit_accepted: false }
        headers = {"CONTENT_TYPE" => "application/json"}
      
        patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate({vendor: vendor_params})
        vendor_1 = Vendor.find_by(id: id)
      
        expect(response).to be_successful

        expect(vendor_1.description).to_not eq(previous_description)
        expect(vendor_1.description).to eq("I sell some really cool things")

        expect(vendor_1.contact_name).to_not eq(previous_contact_name)
        expect(vendor_1.contact_name).to eq("Mr. Cool")

        expect(vendor_1.contact_phone).to_not eq(previous_contact_phone)
        expect(vendor_1.contact_phone).to eq("123-345-4567")

        expect(vendor_1.credit_accepted).to eq(false)
      end
    end

    describe 'can Unsuccessfully update a vendor' do 
      it 'wont update if the vendor doesnt exist' do 
        id = '12323434534534'

        vendor_params = { description: "I sell some really cool things", contact_name: "Mr. Cool", contact_phone: "123-345-4567" }
        headers = {"CONTENT_TYPE" => "application/json"}
      
        patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate({vendor: vendor_params})

        error_message = JSON.parse(response.body, symbolize_names: true)
      
        expect(response).to have_http_status(406)
        
        expect(error_message).to have_key(:errors)
        expect(error_message[:errors]).to be_a(Array)

        expect(error_message[:errors].first).to have_key(:detail)
        expect(error_message[:errors].first[:detail]).to be_a(String)

        expect(error_message[:errors].first[:detail]).to eq("Couldn't find Vendor with 'id'=#{id}")
      end

      it 'wont update if the description is nil' do 
        id = create(:vendor).id

        vendor_params = { description: nil, contact_name: "Mr. Cool", contact_phone: "123-345-4567" }
        headers = {"CONTENT_TYPE" => "application/json"}
      
        patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate({vendor: vendor_params})
      
        error_message = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(400)

        expect(error_message[:errors].first[:detail]).to eq("Validation failed: Description can't be blank")
      end

      it 'wont update if the description is left blank' do 
        id = create(:vendor).id

        vendor_params = { description: '', contact_name: "Mr. Cool", contact_phone: "123-345-4567" }
        headers = {"CONTENT_TYPE" => "application/json"}
      
        patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate({vendor: vendor_params})
      
        error_message = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(400)

        expect(error_message[:errors].first[:detail]).to eq("Validation failed: Description can't be blank")
      end

      it 'wont update if the name is nil' do 
        id = create(:vendor).id

        vendor_params = { description: 'Something cool', name: nil, contact_phone: "123-345-4567" }
        headers = {"CONTENT_TYPE" => "application/json"}
      
        patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate({vendor: vendor_params})
      
        error_message = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(400)

        expect(error_message[:errors].first[:detail]).to eq("Validation failed: Name can't be blank")
      end

      it 'wont update if the name is left blank' do 
        id = create(:vendor).id

        vendor_params = { description: 'Something cool', name: '', contact_phone: "123-345-4567" }
        headers = {"CONTENT_TYPE" => "application/json"}
      
        patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate({vendor: vendor_params})
      
        error_message = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(400)

        expect(error_message[:errors].first[:detail]).to eq("Validation failed: Name can't be blank")
      end

      it 'wont update if the contact_name is nil' do 
        id = create(:vendor).id

        vendor_params = { description: 'Something cool', name: 'Mr Cool', contact_name: nil }
        headers = {"CONTENT_TYPE" => "application/json"}
      
        patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate({vendor: vendor_params})
      
        error_message = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(400)

        expect(error_message[:errors].first[:detail]).to eq("Validation failed: Contact name can't be blank")
      end

      it 'wont update if the contact name is left blank' do 
        id = create(:vendor).id

        vendor_params = { description: 'Something cool', name: 'Mr cool', contact_name: '' }
        headers = {"CONTENT_TYPE" => "application/json"}
      
        patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate({vendor: vendor_params})
      
        error_message = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(400)

        expect(error_message[:errors].first[:detail]).to eq("Validation failed: Contact name can't be blank")
      end

      it 'wont update if the contact phone is nil' do 
        id = create(:vendor).id

        vendor_params = { description: 'Something cool', contact_phone: nil, credit_accepted: true }
        headers = {"CONTENT_TYPE" => "application/json"}
      
        patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate({vendor: vendor_params})
      
        error_message = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(400)

        expect(error_message[:errors].first[:detail]).to eq("Validation failed: Contact phone can't be blank")
      end

      it 'wont update if the contact phone is left blank' do 
        id = create(:vendor).id

        vendor_params = { description: 'Something cool', contact_phone: '', credit_accepted: true }
        headers = {"CONTENT_TYPE" => "application/json"}
      
        patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate({vendor: vendor_params})
      
        error_message = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(400)

        expect(error_message[:errors].first[:detail]).to eq("Validation failed: Contact phone can't be blank")
      end

      it 'wont update if the credit_accepted is nil' do 
        id = create(:vendor).id

        vendor_params = { description: 'Something cool', contact_phone: '23131323123', credit_accepted: nil }
        headers = {"CONTENT_TYPE" => "application/json"}
      
        patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate({vendor: vendor_params})
      
        error_message = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(400)

        expect(error_message[:errors].first[:detail]).to eq("Validation failed: Credit accepted must be a Boolean")
      end
    end
  end
end
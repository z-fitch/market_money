require 'rails_helper'

describe Market, type: :model do
  describe 'relationships' do
    it { should have_many(:market_vendors) }
    it { should have_many(:vendors).through(:market_vendors) }
  end

  describe 'validations' do

  end

  describe 'instance methods' do
    before :each do
      @market = create(:market)
      @vendor_1 = create(:vendor)
      @vendor_2 = create(:vendor)
      @vendor_3 = create(:vendor)

      MarketVendor.create!(market_id: @market.id, vendor_id: @vendor_1.id)
      MarketVendor.create!(market_id: @market.id, vendor_id: @vendor_2.id)
      MarketVendor.create!(market_id: @market.id, vendor_id: @vendor_3.id)
    end
    describe '#vendor_count' do 
      it 'can count the amount of vendors for each market' do
        expect(@market.vendor_count).to eq(3)
      end
    end
  end
end
require 'rails_helper'

describe MarketVendor, type: :model do
  describe 'relationships' do
    it { should belong_to(:market) }
    it { should belong_to(:vendor) }
  end

  describe 'validations' do

  end

  describe 'instance methods' do

  end
end
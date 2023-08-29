require 'rails_helper'

describe Vendor, type: :model do
  describe 'relationships' do
    it { should have_many(:market_vendors) }
    it { should have_many(:markets).through(:market_vendors) }
  end

  describe 'validations' do

  end

  describe 'instance methods' do

  end
end
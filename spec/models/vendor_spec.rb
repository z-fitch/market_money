require 'rails_helper'

describe Vendor, type: :model do
  describe 'relationships' do
    it { should have_many(:market_vendors) }
    it { should have_many(:markets).through(:market_vendors) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :contact_name }
    it { should validate_presence_of :contact_phone }
    it {should allow_value(true).for(:credit_accepted).with_message("must be a Boolean")}
    it {should allow_value(false).for(:credit_accepted).with_message("must be a Boolean")}
    it {should_not allow_value(nil).for(:credit_accepted).with_message("must be a Boolean")}
  end

  describe 'instance methods' do
  end
end
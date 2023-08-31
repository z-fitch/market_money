class MarketVendor < ApplicationRecord
  belongs_to :market, dependent: :destroy
  belongs_to :vendor, dependent: :destroy

  validates :market_id, :vendor_id, presence: true
  validate :already_exists, on: :create

  def already_exists
    if MarketVendor.exists?(market_id: market_id, vendor_id: vendor_id)
      raise ActiveRecord::StatementInvalid, "Validation failed: Market vendor asociation between market with market_id=#{market_id} and vendor_id=#{vendor_id} already exists"
    end
  end
end
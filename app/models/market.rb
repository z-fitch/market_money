class Market < ApplicationRecord
  has_many :market_vendors
  has_many :vendors, through: :market_vendors

  def vendor_count
    self.vendors.count
  end

  def self.search(search_params)
    if validation_for_search(search_params)
      searched_markets(search_params)
    else
      raise ActiveRecord::RecordNotFound, "Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint."
    end
  end

  def self.validation_for_search(search_params)
    current_search = search_params.slice(:state, :city, :name).keys.sort
    vaild_params = [["city", "state" ], ["state"], ["city","name", "state" ], ["name", "state"], ["name"]]
    
    vaild_params.include?(current_search)
  end
  
  def self.searched_markets(search_params)
    filtered_markets = Market.where("state ILIKE ?", "%#{search_params[:state]}%") if search_params.has_key?(:state)
    filtered_markets = Market.where("city ILIKE ?", "%#{search_params[:city]}%") if search_params.has_key?(:city)
    filtered_markets = Market.where("name ILIKE ?", "%#{search_params[:name]}%") if search_params.has_key?(:name)

    filtered_markets
  end
end
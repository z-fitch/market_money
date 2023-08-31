class ErrorMemberSerializer
  def initialize(error_object)
    @error_object = error_object
  end

  def not_found_errors # ! Error formatting 
    {
      errors: [
        {
          detail: @error_object.as_json
        }
      ]
    }
  end

  def no_assoociation_error
    {
      errors: [
        {
          detail: "No MarketVendor with market_id=#{@error_object[0]} AND vendor_id=#{@error_object[1]} exists"
        }
      ]
    }
  end
end

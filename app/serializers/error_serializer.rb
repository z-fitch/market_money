class ErrorSerializer
  def initialize(error_object)
    @error_object = error_object
  end

  def format_errors
    {
      errors: [
        {
          detail: @error_object.as_json
        }
      ]
    }
  end

  def no_association_error
    {
      errors: [
        {
          detail: "No MarketVendor with market_id=#{@error_object[0]} AND vendor_id=#{@error_object[1]} exists"
        }
      ]
    }
  end
end

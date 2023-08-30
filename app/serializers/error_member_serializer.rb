class ErrorMemberSerializer
  def initialize(error_object)
    @error_object = error_object
  end

  def not_found_errors
    {
      errors: [
        {
          detail: @error_object.as_json
        }
      ]
    }
  end
end

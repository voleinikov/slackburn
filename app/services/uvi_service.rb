class UviService

  class << self
    def get_uvi zipcode
      raise ZipEmpty unless zipcode
      raise InvalidZipFormat unless zipcode_format_valid? zipcode
      OpenWeather.get_uvi_by_zip zipcode
    end

    def zipcode_format_valid? z
      # Validates only a short (5 digit) zipcode, which is the only one OpenWeather 
      # geolocation API currently supports (for the US). 
      # If you want to validate both short and long (e.g. 12345-0001) zip codes, you can
      # use the below regex:
      # re = /^[0-9]{5}(?:-[0-9]{4})?$/

      re = /^[0-9]{5}$/ 
      z.match?(re)
    end
  end

  class InvalidZipFormat < CustomError
    def custom_msg
      "Please enter a valid, five-digit zipcode (e.g. 12345)."
    end
  end

  class ZipEmpty < CustomError
    def custom_msg
      "Zipcode cannot be empty.  Please enter a valid, five-digit zipcode (e.g. 12345)."
    end
  end
end

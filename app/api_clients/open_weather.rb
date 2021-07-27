class OpenWeather
  OW_ONECALL_VERSION = 2.5
  OW_GEO_VERSION = 1.0
  OW_ONECALL_URI = "http://api.openweathermap.org/data/#{OW_ONECALL_VERSION}/onecall"
  OW_GEO_ZIP_URI = "http://api.openweathermap.org/geo/#{OW_GEO_VERSION}/zip"
  OW_API_KEY = Rails.application.credentials.external_api_keys[:open_weather]
  OW_ONECALL_DEFAULT_PARAMS = {
    :exclude => 'minutely,hourly,daily,alerts', 
    :appid => OW_API_KEY
  }
  OW_GEO_DEFAULT_PARAMS = {
    :appid => OW_API_KEY
  }
  DEFAULT_COUNTRY_CODE = 'us'

  class << self
    def get_uvi_by_zip zipcode
      get_weather_data({zip: zipcode})["uvi"]
    end

    def get_lat_long_from_zip zipcode
      res = Net::HTTP.get_response(zip_req(zipcode))

      if res.is_a?(Net::HTTPSuccess)
        body = JSON.parse(res.body)
        return body["lat"], body["lon"]
      elsif res.is_a?(Net::HTTPNotFound)
        raise ZipNotFoundError, "Response details: #{res.inspect}, #{res.body}, #{res.code}"
      elsif res.is_a?(Net::HTTPServerError)
        raise GeoApiServerError, "Response details: #{res.inspect}, #{res.body}, #{res.code}"
      else
        raise "Bad lat/long geo request. Response details: #{res.inspect}, #{res.body}, #{res.code}"
      end
    end

    def get_weather_data opts={}
      if opts.any? && opts[:zip]
        lat, lon = get_lat_long_from_zip opts[:zip]

        res = Net::HTTP.get_response(onecall_req(lat, lon))
        if res.is_a?(Net::HTTPSuccess)
          return JSON.parse(res.body)["current"]
        else
          raise OneCallServerError, "Response details: #{res.inspect}, #{res.body}"
        end
      else
        raise 'Need a zip code'
      end
    end

    def zip_req zipcode
      uri = URI(OW_GEO_ZIP_URI)
      params = OW_GEO_DEFAULT_PARAMS.merge({
        :zip => "#{zipcode},#{DEFAULT_COUNTRY_CODE}"
      })
      uri.query = URI.encode_www_form(params)

      uri
    end

    def onecall_req lat, lon
      uri = URI(OW_ONECALL_URI)
      params = OW_ONECALL_DEFAULT_PARAMS.merge({
        :lat => lat,
        :lon => lon
      })
      uri.query = URI.encode_www_form(params)

      uri
    end
  end

  class ZipNotFoundError < CustomError
    def custom_msg
      "We were unable to find the coordinates of your zipcode, are you sure it is correct?"
    end
  end

  class GeoApiServerError < CustomError
    def custom_msg
      "We're sorry, there was an error with the Zip Code service, please try aggin later."
    end
  end

  class OneCallServerError < CustomError
    def custom_msg
      "We're sorry, there was an error with our Weather Service, please try again later."
    end
  end
end
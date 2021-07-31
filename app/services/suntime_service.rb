class SuntimeService
  SKIN_TYPE_COEFFICIENT_MAP = {
    '1'=> 5,
    '2'=> 10,
    '3'=> 15,
    '4'=> 25,
    '5'=> 45,
    '6'=> 90,
  }

  class << self
    def get_sun_time skin_type, uvi, spf
      spf = [spf.to_i, 1].max

      raise InvalidSkinTypeError unless skintype_valid? skin_type
      raise InvalidSPFError if spf > 100
      uvi = [uvi.to_f, 0.1].max

      sun_exposure_minutes(skin_type, spf, uvi)
    end

    
    private

    def skintype_valid? st
      re = /^[1-6]{1}$/ 
      st.match?(re)
    end

    def sun_exposure_minutes skin_type, spf, uvi
      coeff = SKIN_TYPE_COEFFICIENT_MAP[skin_type]

      (coeff*8/uvi)*spf
    end
  end

  class InvalidSkinTypeError < CustomError
    def custom_msg
      "Please enter a skin type from 1 to 6."
    end
  end

  class InvalidSPFError < CustomError
    def custom_msg
      "Please enter an spf value between 0 and 100."
    end
  end
end
class CustomError < StandardError
  def custom_msg
    self.message
  end
end
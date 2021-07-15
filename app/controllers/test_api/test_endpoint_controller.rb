module TestApi
  class TestEndpointController < ApplicationController
    def try_it
      render json: { msg: ['It works!'] }, status: :ok
    end
  end
end
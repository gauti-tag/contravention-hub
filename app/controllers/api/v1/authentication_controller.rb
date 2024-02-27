module Api::V1
  class AuthenticationController < ApplicationController
    skip_before_action :authenticate_request
  
    def authenticate
      result = AuthenticatePlatform.call(api_key: auth_params[:api_key], api_secret: auth_params[:api_secret])
      json_response(result.to_h, result.status)
    end
  
    private
  
    def auth_params
      params.require(:auth).permit(:api_key, :api_secret)
    end
  end
end
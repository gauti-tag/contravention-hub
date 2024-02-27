class ApplicationController < ActionController::API
  include ActionController::Helpers
  include Response
  include ExceptionHandler

  before_action :authenticate_request

  def authenticate_request
    auth_token = request.headers['Authorization'].to_s.split(' ').last
    command = AuthorizeRequest.call(token: auth_token)
    @current_user = command.platform if command.success?

    message = { status: 401, error: 'Not Authorized' }
    json_response(message, :unauthorized) unless current_user
  end

  def current_user
    @current_user
  end

  helper_method :current_user
end

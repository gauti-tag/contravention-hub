module ExceptionHandler
  extend ActiveSupport::Concern
  
  class DecodeError < StandardError; end
  class ExpiredSignature < StandardError; end
  class InvalidPlatform < StandardError; end
  
  included do
    rescue_from ExceptionHandler::DecodeError do |_error|
      render json: {
        message: "Access denied!. Invalid token supplied."
      }, status: :unauthorized
    end
    
    rescue_from ExceptionHandler::ExpiredSignature do |_error|
      render json: {
        message: "Access denied!. Token has expired."
      }, status: :unauthorized
    end

    rescue_from ExceptionHandler::InvalidPlatform do |_error|
      render json: {
        status: 400,
        message: "Invalid platform!. Please check your request body."
      }, status: :bad_request
    end

    rescue_from ActionController::ParameterMissing do |_error|
      render json: {
        status: 400,
        message: "Bad request! Please check your request body."
      }, status: :bad_request
    end

    rescue_from ActionController::RoutingError do |_error|
      render json: {
        status: 404,
        message: "Route not found."
      }, status: :not_found
    end
  end
end

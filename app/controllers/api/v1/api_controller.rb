module Api
  module V1
    class ApiController < ApplicationController
      include ActionController::HttpAuthentication::Token::ControllerMethods
      rescue_from ActionController::UnpermittedParameters, with: :unpermitted_parameters
      rescue_from ActionController::ParameterMissing, with: :parameter_missing

      before_action :authenticate

      protected

      def authenticate
        authenticate_api_key || render_unauthorized
      end

      def authenticate_api_key
        authenticate_with_http_token do |api_key, options|
          api_key == ENV['API_KEY']
        end
      end

      def render_unauthorized(realm = 'Application')
        self.headers['WWW-Authenticate'] = %(Token realm="#{realm}")
        render json: 'Api token is not valid.', status: :unauthorized
      end

      private

      def unpermitted_parameters(error)
        render json: { message: error.message, data: error.params }, status: :bad_request
      end

      def parameter_missing(error)
        render json: { message: error.message, data: error.param }, status: :bad_request
      end
    end
  end
end

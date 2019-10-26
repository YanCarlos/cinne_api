module Api
  module V1
    class ApiController < ApplicationController
      include ActionController::HttpAuthentication::Token::ControllerMethods

      before_action :authenticate

      protected

      def authenticate
        authenticate_api_key || render_unauthorized
      end

      def authenticate_api_key
        authenticate_with_http_token do |token, options|
          token == ENV['API_KEY']
        end
      end

      def render_unauthorized(realm = 'Application')
        self.headers['WWW-Authenticate'] = %(Token realm="#{realm}")
        render json: 'Api token is not valid.', status: :unauthorized
      end
    end
  end
end

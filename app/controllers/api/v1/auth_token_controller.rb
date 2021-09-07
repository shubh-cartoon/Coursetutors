# frozen_string_literal: true

module Api
  module V1
    class AuthTokenController < ApplicationController
      def token
        username = request.headers['username']
        password = request.headers['password']

        if valid_credintials(username, password)
          token = JWT.encode(
            {
              user: [username, password],
              exp: 2.hours.from_now.to_i
            },
            Rails.application.credentials.secret_key_base.to_s,
            'HS256'
          )
          render json: { token: token }, status: :ok
        else
          render json: { status: false, message: I18n.t('errors.invalid_credentials') }, status: :unauthorized
        end
      end

      private

      def valid_credintials(username, password)
        username.eql?(ENV['API_USER']) && password.eql?(ENV['API_USER_PASSWORD'])
      end
    end
  end
end

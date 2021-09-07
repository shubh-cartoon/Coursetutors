# frozen_string_literal: true

module AuthenticationConcern
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user_from_token!
  end

  private

  def authenticate_user_from_token!
    token = request.headers['HTTP_AUTHORIZATION']
    if token
      user = get_user_from(token)
      if user
        session[:user] = user
      else
        @error = I18n.t('errors.invalid_credentials') and render_unauthorized
      end
    else
      @error = I18n.t('errors.no_token') and render_unauthorized
    end
  end

  def get_user_from(token)
    token = token.gsub(/Bearer /, '')

    payload = JWT.decode(token, Rails.application.credentials.secret_key_base).first

    ENV['API_USER'] if ENV['API_USER'].eql?(payload['user'][0]) && ENV['API_USER_PASSWORD'].eql?(payload['user'][1])
  end

  def render_unauthorized
    render json: { errors: [@error] }, status: :unauthorized
  end
end

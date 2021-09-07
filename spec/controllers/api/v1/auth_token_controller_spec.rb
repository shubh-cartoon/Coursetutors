# frozen_string_literal: true

require 'rails_helper'

def generate_token
  JWT.encode(
    {
      user: [ENV['API_USER'], ENV['API_USER_PASSWORD']],
      exp: 2.hours.from_now.to_i
    },
    Rails.application.credentials.secret_key_base.to_s,
    'HS256'
  )
end

RSpec.describe Api::V1::AuthTokenController, type: :controller do
  describe '#token' do
    context 'wrong username and password in headers' do
      it 'should return invalid_credentials error' do
        get :token

        expect(response.status).to eq(401)
        expect(JSON.parse(response.body)['message']).to eq(I18n.t('errors.invalid_credentials'))
      end
    end

    context 'correct username and password in headers' do
      before do
        request.headers['username'] = ENV['API_USER']
        request.headers['password'] = ENV['API_USER_PASSWORD']
      end
      it 'should return auth token' do
        get :token

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['token']).to eq(generate_token)
      end
    end
  end
end

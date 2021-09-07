# frozen_string_literal: true

require 'rails_helper'

def get_token(pass = ENV['API_USER_PASSWORD'])
  JWT.encode(
    {
      user: [ENV['API_USER'], pass],
      exp: 2.hours.from_now.to_i
    },
    Rails.application.credentials.secret_key_base.to_s,
    'HS256'
  )
end

RSpec.describe Api::V1::CoursesController, type: :controller do
  describe '#index' do
    context 'Unauthorized request' do
      it 'Unauthorized request for no token' do
        post :index

        expect(response.status).to eq(401)
        expect(JSON.parse(response.body)['errors'][0]).to eq(I18n.t('errors.no_token'))
      end

      it 'Unauthorized request for invalid token' do
        request.headers['HTTP_AUTHORIZATION'] = "Bearer #{get_token('temp')}"

        post :index

        expect(response.status).to eq(401)
        expect(JSON.parse(response.body)['errors'][0]).to eq(I18n.t('errors.invalid_credentials'))
      end
    end

    context 'Authorized request' do
      before do
        request.headers['HTTP_AUTHORIZATION'] = "Bearer #{get_token}"
      end
      it 'return data' do
        course = create(:course)
        tutor  = create(:tutor, course: course)

        post :index

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq(
          {
            'data' => [
              {
                'code' => 'CSE-01',
                'name' => 'DSA',
                'tutors' => [
                  {
                    'name' => 'test-tutor',
                    'aadhar' => '123456789012'
                  }
                ]
              }
            ]
          }
        )
      end
    end
  end

  describe '#create' do
    context 'Authorized request' do
      before do
        request.headers['HTTP_AUTHORIZATION'] = "Bearer #{get_token}"
      end
      it 'create course and its tutors' do
        params = {
          "course":
            {
              "name": 'DSA1',
              "code": 'AB002',
              "tutors_attributes":
              [
                { "name": 'test', "aadhar": '513992000631' },
                { "name": 'test2', "aadhar": '123456789011' }
              ]
            }
        }

        post :create, params: params

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['message']).to eq(I18n.t('course.created'))
      end

      it 'should not create course and its tutors' do
        course = create(:course, code: 'AB002')
        tutor = create(:tutor, aadhar: '513992000631', course: course)

        params = {
          "course":
            {
              "name": 'DSA1',
              "code": 'AB002',
              "tutors_attributes":
              [
                { "name": 'test', "aadhar": '513992000631' },
                { "name": 'test2', "aadhar": '123456789011' }
              ]
            }
        }

        post :create, params: params

        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)['message']).to eq(
          'Tutors aadhar has already been taken,Code has already been taken'
        )
      end
    end
  end
end

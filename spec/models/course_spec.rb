# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Course, type: :model do
  describe 'validation' do
    it { should have_many(:tutors) }
    it { should validate_presence_of(:code) }
    it { should validate_presence_of(:name) }
  end
end

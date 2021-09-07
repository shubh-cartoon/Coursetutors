# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tutor, type: :model do
  describe 'validation' do
    it { should belong_to(:course) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:aadhar) }
  end
end

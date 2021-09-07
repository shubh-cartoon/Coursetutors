# frozen_string_literal: true

class Tutor < ApplicationRecord
  belongs_to :course

  validates :name, presence: true
  validates :aadhar, presence: true, uniqueness: true, length: { is: 12 }
end

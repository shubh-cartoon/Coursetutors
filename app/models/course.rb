# frozen_string_literal: true

class Course < ApplicationRecord
  has_many :tutors, dependent: :destroy

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true

  accepts_nested_attributes_for :tutors
end

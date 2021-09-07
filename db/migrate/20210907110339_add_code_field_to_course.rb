# frozen_string_literal: true

class AddCodeFieldToCourse < ActiveRecord::Migration[6.1]
  def up
    add_column :courses, :code, :string, null: false, index: true
  end

  def down
    remove_column :courses, :code, :string
  end
end

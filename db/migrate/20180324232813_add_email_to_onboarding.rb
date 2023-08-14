# frozen_string_literal: true

class AddEmailToOnboarding < ActiveRecord::Migration[5.1]
  def change
    add_column :onboardings, :email, :string
  end
end

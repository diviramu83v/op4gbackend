# frozen_string_literal: true

class AddErrorMessageToOnboarding < ActiveRecord::Migration[5.1]
  def change
    add_column :onboardings, :error_message, :string
  end
end

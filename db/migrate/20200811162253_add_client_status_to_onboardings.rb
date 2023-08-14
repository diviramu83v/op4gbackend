# frozen_string_literal: true

class AddClientStatusToOnboardings < ActiveRecord::Migration[5.2]
  def change
    add_column :onboardings, :client_status, :string
  end
end

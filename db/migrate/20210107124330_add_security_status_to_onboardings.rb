# frozen_string_literal: true

class AddSecurityStatusToOnboardings < ActiveRecord::Migration[5.2]
  def change
    add_column :onboardings, :security_status, :string
  end
end

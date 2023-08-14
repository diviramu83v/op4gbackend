# frozen_string_literal: true

class AddBypassedPrescreenerAtToOnboardings < ActiveRecord::Migration[5.2]
  def change
    add_column :onboardings, :bypassed_all_at, :datetime
  end
end

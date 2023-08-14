# frozen_string_literal: true

class AddRejectedReasonToOnboarding < ActiveRecord::Migration[6.1]
  def change
    add_column :onboardings, :rejected_reason, :string
  end
end

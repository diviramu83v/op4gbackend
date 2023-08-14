# frozen_string_literal: true

class AddCheckCleanIdToOnramps < ActiveRecord::Migration[5.2]
  def change
    add_column :onramps, :check_clean_id, :boolean
    add_column :onboardings, :clean_id_token, :string
    add_column :onboardings, :clean_id_started_at, :datetime
    add_column :onboardings, :clean_id_passed_at, :datetime
  end
end

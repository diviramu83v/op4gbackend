# frozen_string_literal: true

class RemoveFailedAtColumns < ActiveRecord::Migration[5.1]
  def change
    remove_column :onboardings, :relevant_id_failed_at, :datetime
    remove_column :onboardings, :recaptcha_failed_at, :datetime
  end
end

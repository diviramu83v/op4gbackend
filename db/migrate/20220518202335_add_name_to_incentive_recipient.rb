# frozen_string_literal: true

class AddNameToIncentiveRecipient < ActiveRecord::Migration[6.0]
  # rubocop:disable Rails/BulkChangeTable
  def change
    add_column :incentive_recipients, :first_name, :string
    add_column :incentive_recipients, :last_name, :string
    remove_column :incentive_recipients, :uid, :string
    remove_reference :incentive_recipients, :onboarding, index: true, foreign_key: true
  end
  # rubocop:enable Rails/BulkChangeTable
end

# frozen_string_literal: true

class RemoveOplusIdFromPanelists < ActiveRecord::Migration[5.2]
  def change
    # rubocop:disable Rails/BulkChangeTable
    remove_column :panelists, :oplus_id, :string
    remove_column :panelists, :newsletter, :boolean
    remove_column :panelists, :general_communications, :boolean
    remove_column :panelists, :share_email, :boolean
    remove_column :panelists, :paypal, :boolean
    remove_column :panelists, :activity_email_frequency, :string
    remove_column :panelists, :payout_threshold, :string
    # rubocop:enable Rails/BulkChangeTable
  end
end

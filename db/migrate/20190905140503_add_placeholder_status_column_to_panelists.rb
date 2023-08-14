# frozen_string_literal: true

class AddPlaceholderStatusColumnToPanelists < ActiveRecord::Migration[5.1]
  # rubocop:disable Rails/SkipsModelValidations
  def change
    add_column :panelists, :status_holder, :string, null: false, default: 'signing_up'

    Panelist.where(status: 0).update_all(status_holder: 'signing_up')
    Panelist.where(status: 1).update_all(status_holder: 'active')
    Panelist.where(status: 2).update_all(status_holder: 'suspended')
    Panelist.where(status: 3).update_all(status_holder: 'deleted')
    Panelist.where(status: 4).update_all(status_holder: 'deactivated')

    remove_column :panelists, :status, :integer
  end
  # rubocop:enable Rails/SkipsModelValidations
end

# frozen_string_literal: true

class AddSuspendAndPayStatusToPanelists < ActiveRecord::Migration[5.2]
  def change
    add_column :panelists, :suspend_and_pay_status, :boolean
  end
end

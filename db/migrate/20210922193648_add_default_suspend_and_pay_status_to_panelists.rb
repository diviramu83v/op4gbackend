# frozen_string_literal: true

class AddDefaultSuspendAndPayStatusToPanelists < ActiveRecord::Migration[5.2]
  def change
    change_column_default :panelists, :suspend_and_pay_status, from: nil, to: false
  end
end

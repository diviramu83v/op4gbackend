# frozen_string_literal: true

class BackportPanelistSuspendAndPayStatus < ActiveRecord::Migration[5.2]
  # rubocop:disable Rails/SkipsModelValidations
  def change
    Panelist.find_each do |panelist|
      next unless panelist.suspend_and_pay_status.nil?

      panelist.update_column(:suspend_and_pay_status, false)
    end
  end
  # rubocop:enable Rails/SkipsModelValidations
end

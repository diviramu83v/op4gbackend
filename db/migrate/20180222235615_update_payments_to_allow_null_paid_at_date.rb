# frozen_string_literal: true

class UpdatePaymentsToAllowNullPaidAtDate < ActiveRecord::Migration[5.1]
  def change
    change_column_null(:payments, :paid_at, true)
  end
end

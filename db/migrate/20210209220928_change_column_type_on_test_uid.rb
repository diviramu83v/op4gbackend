# frozen_string_literal: true

class ChangeColumnTypeOnTestUid < ActiveRecord::Migration[5.2]
  def change
    change_column :test_uids, :uid, :integer, using: 'uid::integer'
    change_column_null :test_uids, :employee_id, false
    change_column_null :test_uids, :onramp_id, false
    change_column_null :test_uids, :uid, false
  end
end

# frozen_string_literal: true

class FixSchemaIssue < ActiveRecord::Migration[5.2]
  def change
    change_column_default :onboardings, :security_status, from: nil, to: 'unsecured'
    change_column_null :onboardings, :security_status, false
  end
end

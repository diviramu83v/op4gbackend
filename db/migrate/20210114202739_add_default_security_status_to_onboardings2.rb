# frozen_string_literal: true

class AddDefaultSecurityStatusToOnboardings2 < ActiveRecord::Migration[5.2]
  def change
    change_column_default :onboardings, :security_status, from: nil, to: 'unsecured'
  end
end

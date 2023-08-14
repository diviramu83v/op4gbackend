# frozen_string_literal: true

class SetOnboardingsSecurityStatusToNotNull2 < ActiveRecord::Migration[5.2]
  def change
    change_column_null :onboardings, :security_status, false
  end
end

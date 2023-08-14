# frozen_string_literal: true

class AddDefaultIgnoreSecurityFlagsToOnramps < ActiveRecord::Migration[5.2]
  def change
    change_column_default :onramps, :ignore_security_flags, from: nil, to: false
  end
end

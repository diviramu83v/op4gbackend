# frozen_string_literal: true

class SetOnrampIgnoreSecurityFlagsToNotNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :onramps, :ignore_security_flags, false
  end
end

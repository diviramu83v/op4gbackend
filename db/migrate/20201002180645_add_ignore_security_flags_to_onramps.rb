# frozen_string_literal: true

class AddIgnoreSecurityFlagsToOnramps < ActiveRecord::Migration[5.2]
  def change
    add_column :onramps, :ignore_security_flags, :boolean
  end
end

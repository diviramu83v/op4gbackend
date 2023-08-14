# frozen_string_literal: true

class AddBypassDatetimeToOnboarding < ActiveRecord::Migration[5.1]
  def change
    add_column :onboardings, :bypassed_security_at, :datetime
  end
end

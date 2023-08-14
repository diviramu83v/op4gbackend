# frozen_string_literal: true

class BackportDefaultIgnoreSecurityFlagsToOnramps < ActiveRecord::Migration[5.2]
  def up
    Onramp.where(ignore_security_flags: nil).find_each do |onramp|
      # rubocop:disable Rails/SkipsModelValidations
      if onramp&.vendor&.name == 'Trade Partner'
        onramp.update_columns(ignore_security_flags: true)
      else
        onramp.update_columns(ignore_security_flags: false)
      end
      # rubocop:enable Rails/SkipsModelValidations
    end
  end
end

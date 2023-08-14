# frozen_string_literal: true

class AddDisabledAtToOnramp < ActiveRecord::Migration[5.1]
  def change
    add_column :onramps, :disabled_at, :datetime
  end
end

# frozen_string_literal: true

class AddStatusHolderToOnboardings < ActiveRecord::Migration[5.1]
  def change
    add_column :onboardings, :status_holder, :string, null: false, default: 'initialized'
  end
end

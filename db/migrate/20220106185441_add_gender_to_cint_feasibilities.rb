# frozen_string_literal: true

class AddGenderToCintFeasibilities < ActiveRecord::Migration[5.2]
  def change
    add_column :cint_feasibilities, :gender, :string
  end
end

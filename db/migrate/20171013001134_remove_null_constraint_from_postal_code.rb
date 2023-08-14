# frozen_string_literal: true

class RemoveNullConstraintFromPostalCode < ActiveRecord::Migration[5.1]
  def change
    change_column_null :panelists, :postal_code, true
  end
end

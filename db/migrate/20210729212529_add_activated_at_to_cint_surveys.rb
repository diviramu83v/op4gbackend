# frozen_string_literal: true

class AddActivatedAtToCintSurveys < ActiveRecord::Migration[5.2]
  def change
    add_column :cint_surveys, :activated_at, :datetime
  end
end

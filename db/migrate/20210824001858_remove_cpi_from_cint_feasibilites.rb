# frozen_string_literal: true

class RemoveCpiFromCintFeasibilites < ActiveRecord::Migration[5.2]
  def change
    remove_column :cint_feasibilities, :cpi, :integer
  end
end

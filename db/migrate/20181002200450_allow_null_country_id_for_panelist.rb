# frozen_string_literal: true

class AllowNullCountryIdForPanelist < ActiveRecord::Migration[5.1]
  def change
    change_column_null :panelists, :country_id, true
  end
end

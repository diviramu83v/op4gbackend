# frozen_string_literal: true

class RemoveNpomColumns < ActiveRecord::Migration[5.1]
  def change
    remove_column :nonprofits, :made_nonprofit_of_the_month_at, :datetime
    remove_column :panelists, :supports_npom, :boolean, null: false, default: false
    remove_column :earnings, :npom, :boolean, default: false, null: false
  end
end

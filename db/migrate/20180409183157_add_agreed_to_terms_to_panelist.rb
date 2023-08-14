# frozen_string_literal: true

class AddAgreedToTermsToPanelist < ActiveRecord::Migration[5.1]
  def change
    add_column :panelists, :agreed_to_terms_at, :datetime
  end
end

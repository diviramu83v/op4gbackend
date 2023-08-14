# frozen_string_literal: true

class AddPanelistToOnboarding < ActiveRecord::Migration[5.1]
  def change
    add_reference :onboardings, :panelist, foreign_key: true
  end
end

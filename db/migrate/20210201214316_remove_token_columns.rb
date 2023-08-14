# frozen_string_literal: true

class RemoveTokenColumns < ActiveRecord::Migration[5.2]
  def change
    remove_column :survey_routers, :token, :string
    remove_column :customer_survey_invitations, :token, :string
  end
end

# frozen_string_literal: true

class AddDefaultDisqoParamsToOnboardings < ActiveRecord::Migration[5.2]
  def change
    change_column :onboardings, :disqo_params, :jsonb, default: {}
  end
end

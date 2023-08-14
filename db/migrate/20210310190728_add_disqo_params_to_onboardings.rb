# frozen_string_literal: true

class AddDisqoParamsToOnboardings < ActiveRecord::Migration[5.2]
  def change
    add_column :onboardings, :disqo_params, :jsonb
  end
end

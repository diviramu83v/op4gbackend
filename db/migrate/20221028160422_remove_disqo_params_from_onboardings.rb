# frozen_string_literal: true

class RemoveDisqoParamsFromOnboardings < ActiveRecord::Migration[6.1]
  def change
    safety_assured { remove_column :onboardings, :disqo_params, :jsonb }
  end
end

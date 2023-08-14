# frozen_string_literal: true

class AddTemporaryKeysToSurvey < ActiveRecord::Migration[5.2]
  def change
    add_column :surveys, :temporary_keys, :text, array: true
  end
end

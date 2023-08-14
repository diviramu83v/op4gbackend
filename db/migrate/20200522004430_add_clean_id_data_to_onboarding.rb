# frozen_string_literal: true

class AddCleanIdDataToOnboarding < ActiveRecord::Migration[5.2]
  def change
    add_column :onboardings, :clean_id_data, :json
  end
end

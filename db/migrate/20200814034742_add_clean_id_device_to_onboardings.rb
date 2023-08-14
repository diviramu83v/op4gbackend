# frozen_string_literal: true

class AddCleanIdDeviceToOnboardings < ActiveRecord::Migration[5.2]
  def change
    add_reference :onboardings, :clean_id_device, foreign_key: true
  end
end

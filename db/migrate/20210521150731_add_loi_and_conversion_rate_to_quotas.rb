# frozen_string_literal: true

class AddLoiAndConversionRateToQuotas < ActiveRecord::Migration[5.2]
  def change
    change_table :quotas, bulk: true do |t|
      t.integer :loi, null: false
      t.integer :conversion_rate, null: false
    end
  end
end

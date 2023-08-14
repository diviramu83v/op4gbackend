# frozen_string_literal: true

class AddStatusToIncentiveBatches < ActiveRecord::Migration[6.0]
  def change
    safety_assured { add_column :incentive_batches, :status, :string, default: 'waiting', null: false }
  end
end

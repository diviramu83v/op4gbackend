# frozen_string_literal: true

class AddSampleTypeIdToSchlesingerQuota < ActiveRecord::Migration[6.1]
  def change
    add_column :schlesinger_quotas, :sample_type_id, :bigint
  end
end

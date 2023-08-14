# frozen_string_literal: true

class AddStudyTypeIdToSchlesingerQuota < ActiveRecord::Migration[6.1]
  def change
    add_column :schlesinger_quotas, :study_type_id, :bigint
  end
end

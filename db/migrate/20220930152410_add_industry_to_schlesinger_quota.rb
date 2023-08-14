# frozen_string_literal: true

class AddIndustryToSchlesingerQuota < ActiveRecord::Migration[6.1]
  def change
    add_column :schlesinger_quotas, :industry_id, :bigint
  end
end

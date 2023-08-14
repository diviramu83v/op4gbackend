# frozen_string_literal: true

class AddCsvDataToExpertRecruitBatches < ActiveRecord::Migration[5.2]
  def change
    add_column :expert_recruit_batches, :csv_data, :text
  end
end

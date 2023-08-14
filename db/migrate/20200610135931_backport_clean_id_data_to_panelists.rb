# frozen_string_literal: true

class BackportCleanIdDataToPanelists < ActiveRecord::Migration[5.2]
  # rubocop:disable Rails/SkipsModelValidations
  def change
    Panelist.select(:id).find_in_batches do |records|
      Panelist.where(id: records).update_all(clean_id_data: {})
    end
  end
  # rubocop:enable Rails/SkipsModelValidations
end

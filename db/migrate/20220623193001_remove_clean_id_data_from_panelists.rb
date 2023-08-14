# frozen_string_literal: true

class RemoveCleanIdDataFromPanelists < ActiveRecord::Migration[6.1]
  def change
    Panelist.select(:id).find_in_batches do |records|
      Panelist.where(id: records).update_all(clean_id_data: nil) # rubocop:disable Rails/SkipsModelValidations
    end
  end
end

# frozen_string_literal: true

class BackportDefaultVerifiedFlagToPanelists < ActiveRecord::Migration[5.2]
  def change
    Panelist.select(:id).find_in_batches.with_index do |records, _index|
      # rubocop:disable Rails/SkipsModelValidations
      Panelist.where(id: records).update_all(verified_flag: false)
      # rubocop:enable Rails/SkipsModelValidations
    end
  end
end

# frozen_string_literal: true

class BackportDefaultCheckPrescreenerToOnramps < ActiveRecord::Migration[5.2]
  # rubocop:disable Rails/SkipsModelValidations
  def change
    Onramp.select(:id).find_in_batches.with_index do |records, _index|
      Onramp.where(id: records).update_all(check_prescreener: false)
    end
  end
  # rubocop:enable Rails/SkipsModelValidations
end

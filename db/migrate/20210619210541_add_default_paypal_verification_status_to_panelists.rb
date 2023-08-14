# frozen_string_literal: true

class AddDefaultPaypalVerificationStatusToPanelists < ActiveRecord::Migration[5.2]
  # rubocop:disable Rails/SkipsModelValidations
  def change
    Panelist.select(:id).find_in_batches.with_index do |records, _index|
      Panelist.where(id: records).update_all(paypal_verification_status: 'not_verified')
    end
  end
  # rubocop:enable Rails/SkipsModelValidations
end

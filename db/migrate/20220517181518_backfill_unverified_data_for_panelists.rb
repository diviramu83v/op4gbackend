# frozen_string_literal: true

class BackfillUnverifiedDataForPanelists < ActiveRecord::Migration[6.0]
  # rubocop:disable Rails/SkipsModelValidations
  def up
    Panelist.where(paypal_verification_status: 'not_verified').in_batches.update_all(paypal_verification_status: 'unverified')
  end

  def down
    Panelist.where(paypal_verification_status: 'unverified').in_batches.update_all(paypal_verification_status: 'not_verified')
  end
  # rubocop:enable Rails/SkipsModelValidations
end

# frozen_string_literal: true

class FixVendorOnramps < ActiveRecord::Migration[5.1]
  def up
    # rubocop:disable Rails/SkipsModelValidations
    Onramp.testing.where.not(vendor_batch: nil).update_all(category: Onramp.categories[:vendor])
    # rubocop:enable Rails/SkipsModelValidations
  end
end

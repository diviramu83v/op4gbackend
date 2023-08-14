# frozen_string_literal: true

class AddCategoryToOnramps < ActiveRecord::Migration[5.1]
  # rubocop:disable Rails/SkipsModelValidations
  def change
    add_column :onramps, :category, :string, null: false, default: Onramp.categories[:testing]

    Onramp.where.not(vendor_batch: nil).update_all(category: Onramp.categories[:vendor])
    Onramp.where.not(survey_router: nil).update_all(category: Onramp.categories[:router])
    Onramp.where(category: nil).update_all(category: Onramp.categories[:testing])
  end
  # rubocop:enable Rails/SkipsModelValidations
end

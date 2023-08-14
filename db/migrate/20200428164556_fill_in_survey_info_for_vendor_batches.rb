# frozen_string_literal: true

class FillInSurveyInfoForVendorBatches < ActiveRecord::Migration[5.2]
  # rubocop:disable Rails/SkipsModelValidations
  def change
    VendorBatch.find_each do |vendor_batch|
      vendor_batch.update_column(:survey_id, vendor_batch.campaign.survey.id)
    end
  end
  # rubocop:enable Rails/SkipsModelValidations
end

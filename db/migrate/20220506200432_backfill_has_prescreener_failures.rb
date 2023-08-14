# frozen_string_literal: true

class BackfillHasPrescreenerFailures < ActiveRecord::Migration[5.2]
  def change
    Onramp.find_in_batches(batch_size: 500) do |batch|
      batch.each do |onramp|
        has_failed_prescreeners = onramp.onboardings.includes([:prescreener_questions]).exists? { |onboarding| onboarding.prescreener_questions.failed.any? }
        onramp.update(has_prescreener_failures: has_failed_prescreeners)
      end
    end
  end
end

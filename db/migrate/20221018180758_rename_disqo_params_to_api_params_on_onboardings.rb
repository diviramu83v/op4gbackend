# frozen_string_literal: true

class RenameDisqoParamsToApiParamsOnOnboardings < ActiveRecord::Migration[6.1]
  def change
    add_column :onboardings, :api_params, :jsonb, default: {}

    Onramp.disqo.find_each do |onramp|
      onramp.onboardings.where.not(disqo_params: nil).find_in_batches do |records|
        records.each do |onboarding|
          onboarding.update_column(:api_params, onboarding.disqo_params) # rubocop:disable Rails/SkipsModelValidations
        end
      end
    end
  end
end

# frozen_string_literal: true

class BackfillNewOnboardingsSecurityStatus2 < ActiveRecord::Migration[5.2]
  # rubocop:disable Rails/SkipsModelValidations
  def up
    Onboarding.where(security_status: nil).find_each do |onboarding|
      if onboarding.onramp.testing? || onboarding.bypassed_security_at.present?
        onboarding.update_columns(security_status: 'other')
      elsif onboarding.onramp_secured?
        onboarding.update_columns(security_status: 'secured')
      else
        onboarding.update_columns(security_status: 'unsecured')
      end
    end
  end
  # rubocop:enable Rails/SkipsModelValidations
end

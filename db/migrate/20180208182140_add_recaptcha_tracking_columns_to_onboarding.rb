# frozen_string_literal: true

class AddRecaptchaTrackingColumnsToOnboarding < ActiveRecord::Migration[5.1]
  def change
    add_column :onboardings, :recaptcha_started_at, :datetime
    add_column :onboardings, :recaptcha_failed_at, :datetime
    add_column :onboardings, :recaptcha_passed_at, :datetime
  end
end

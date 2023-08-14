# frozen_string_literal: true

class UpdateOnboardingStatusHolder < ActiveRecord::Migration[5.1]
  # rubocop:disable Rails/SkipsModelValidations
  def up
    # This was running slowly on Heroku. We're hitting the I/O limit.

    # Onboarding.where(status: 1).update_all(status_holder: 'blocked')
    # Onboarding.where(status: 2).update_all(status_holder: 'screened')
    # Onboarding.where(status: 3).update_all(status_holder: 'survey_started')
    # Onboarding.where(status: 4).update_all(status_holder: 'survey_finished')

    # Ran these before running this migration to fill in the empty column data.
    # Repeating here for final update (inside a transaction) and local environment update.
    Onboarding.where(status: 1).where.not(status_holder: 'blocked').find_in_batches(batch_size: 100) do |batch|
      batch.each do |onboarding|
        onboarding.update_column('status_holder', 'blocked')
      end
      sleep(1) unless Rails.env.development?
    end
    Onboarding.where(status: 2).where.not(status_holder: 'screened').find_in_batches(batch_size: 100) do |batch|
      batch.each do |onboarding|
        onboarding.update_column('status_holder', 'screened')
      end
      sleep(1) unless Rails.env.development?
    end
    Onboarding.where(status: 3).where.not(status_holder: 'survey_started').find_in_batches(batch_size: 100) do |batch|
      batch.each do |onboarding|
        onboarding.update_column('status_holder', 'survey_started')
      end
      sleep(1) unless Rails.env.development?
    end
    Onboarding.where(status: 4).where.not(status_holder: 'survey_finished').find_in_batches(batch_size: 100) do |batch|
      batch.each do |onboarding|
        onboarding.update_column('status_holder', 'survey_finished')
      end
      sleep(1) unless Rails.env.development?
    end

    remove_column :onboardings, :status, :integer
    rename_column :onboardings, :status_holder, :status
  end
  # rubocop:enable Rails/SkipsModelValidations

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

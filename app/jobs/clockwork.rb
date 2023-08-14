# frozen_string_literal: true

require 'clockwork'
require 'active_support/time'
require_relative '../../config/environment'

# this implementation of the Clockwork gem is run in a separate process by the Procfile.
# Tasks that need to run at regularly scheduled times should be implemented here.
module Clockwork
  # Suppressing clock jobs for normal development.
  # Just trying to make things a little less noisy.
  unless Rails.env.development?
    every 1.minute, 'minute clock tasks' do
      WorkerScalingJob.perform_later
    end

    every 1.hour, 'hourly clock tasks' do
      ProjectReportCreationJob.perform_later
      SurveyWarningJob.perform_later
      EmailConfirmationReminderJob.perform_later
      SignupReminderEmailJob.perform_later
      AddSuspiciousIpsToDenylistJob.perform_later
    end

    every 2.hours, 'semi hourly clock tasks' do
      SyncDisqoStatusJob.perform_later
      SyncSchlesingerStatusJob.perform_async
    end

    every 1.day, 'daily morning tasks', at: '16:00' do
      MadMimiProcessDangerBatchJob.perform_later
    end

    every 1.day, 'daily off-hours tasks', at: '07:35' do
      DataCleanupJob.perform_later
      CalculatePanelistAgesJob.perform_later
      DeactivateStalePanelistsJob.perform_later
      SuspendOutOfCountryPanelistsJob.perform_later
      CalculatePanelistScorePercentileJob.perform_later
      ResetSuspendedPanelistsScoresAndScorePercentilesJob.perform_later
      UpdatePanelistAverageReactionTimeJob.perform_later
    end

    every 10.minutes, 'survey payload caching' do
      CacheSurveyPayloadJob.perform_async
    end

    every 1.week, 'sync our questions and answers with schlesinger' do
      SyncSchlesingerQualificationsJob.perform_async
    end
  end
end

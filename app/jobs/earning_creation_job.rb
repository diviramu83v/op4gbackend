# frozen_string_literal: true

# The job that creates a panelist earning record. For company panelists only.
#   Triggered by payment endpoint or manual upload.
class EarningCreationJob < ApplicationJob
  queue_as :default

  def perform(onboarding)
    project = onboarding.project
    return if project.blank?

    panelist = onboarding.panelist
    return if panelist.blank?

    invitation = onboarding.invitation
    return if invitation.blank?

    batch = invitation.batch
    return if batch.blank?

    # Don't repeat creating the payment if this job happens to get called more than once.
    panelist.earnings.create!(sample_batch: batch, total_amount: batch.incentive) if Earning.find_by(panelist: panelist, sample_batch: batch).blank?
  end
end

# frozen_string_literal: true

# This job creates expert recruits
class CreateExpertRecruitsJob < ApplicationJob
  queue_as :default

  def perform(batch, survey)
    batch.first_names_and_emails.each do |email, first_name|
      next if ExpertRecruitUnsubscription.find_by(email: email).present? || Unsubscription.find_by(email: email).present?

      survey.expert_recruits.create(email: email, expert_recruit_batch: batch, description: batch.description, first_name: first_name)
    end
  end
end

# frozen_string_literal: true

# This job adds prescreener answer templates from a file
class DestroyAllPrescreenerAnswerTemplatesJob < ApplicationJob
  queue_as :ui

  def perform(prescreener_question)
    prescreener_question.prescreener_answer_templates.find_in_batches(batch_size: 500) do |batch|
      batch.each(&:destroy)
    end

    PrescreenerAnswerUploadChannel.broadcast_to(prescreener_question, 'success')
  end
end

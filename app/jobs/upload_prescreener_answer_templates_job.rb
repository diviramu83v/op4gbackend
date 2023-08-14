# frozen_string_literal: true

# This job adds prescreener answer templates from a file
class UploadPrescreenerAnswerTemplatesJob < ApplicationJob
  queue_as :ui

  def perform(prescreener_question)
    prescreener_question.temporary_answers.each do |temporary_answer|
      target = temporary_answer.second&.downcase == 't'
      prescreener_question.prescreener_answer_templates.create(body: temporary_answer.first, target: target)
    end

    prescreener_question.update(temporary_answers: [])

    PrescreenerAnswerUploadChannel.broadcast_to(prescreener_question, 'success')
  end
end

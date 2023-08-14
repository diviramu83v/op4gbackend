# frozen_string_literal: true

# Bulk upload prescreener answers
class PrescreenerAnswerUploadChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug 'Subscribed to the prescreener upload channel.'
    prescreener_question = PrescreenerQuestionTemplate.find(params[:prescreener_question])
    stream_for prescreener_question
  end

  def unsubscribed
    Rails.logger.debug 'Unsubscribed from the prescreener upload channel.'
  end
end

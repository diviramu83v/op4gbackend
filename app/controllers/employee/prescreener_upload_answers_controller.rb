# frozen_string_literal: true

# This displays the answers csv upload form
class Employee::PrescreenerUploadAnswersController < Employee::OperationsBaseController
  authorize_resource class: 'PrescreenerAnswerTemplate'

  before_action :set_question_template, only: [:new, :create]

  def new; end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def create
    if params[:upload]
      if params[:upload][:answer_upload]
        process_answer_upload
        redirect_to prescreener_question_answers_url(@prescreener_question)
      else
        flash.now[:alert] = 'No file was uploaded'
        render 'new'
      end
    end
  rescue CSV::MalformedCSVError
    flash.now[:alert] = 'Unable to upload CSV. Please check to make sure the formatting is correct.'
    redirect_to new_prescreener_question_prescreener_upload_answer_url(@prescreener_question)
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  private

  def set_question_template
    @prescreener_question = PrescreenerQuestionTemplate.find(params[:prescreener_question_id])
  end

  # rubocop:disable Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
  def process_answer_upload
    CSV.foreach(params[:upload][:answer_upload].path, headers: false) do |row|
      next if row.first.blank?
      next if @prescreener_question.prescreener_answer_templates.pluck(:body).map(&:downcase).include?(row.first&.downcase&.strip)

      target = row.second&.downcase == 'target' || row.second&.downcase == 'true'
      @prescreener_question.temporary_answers << [row.first, target]
    end
    @prescreener_question.save!
    UploadPrescreenerAnswerTemplatesJob.perform_later(@prescreener_question)
  end
  # rubocop:enable Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
end

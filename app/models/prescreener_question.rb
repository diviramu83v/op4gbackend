# frozen_string_literal: true

# prescreener questions will be new and cool
class PrescreenerQuestion < ApplicationRecord
  has_secure_token

  belongs_to :template, class_name: 'PrescreenerQuestionTemplate', inverse_of: :prescreener_questions, foreign_key: :prescreener_question_template_id
  belongs_to :onboarding

  enum status: {
    complete: 'complete',
    incomplete: 'incomplete'
  }

  after_update :set_failed

  validates :status, presence: true

  scope :by_sort_order, -> { order('sort_order') }
  scope :failed, -> { where(failed: true) }

  def set_failed
    update_column(:failed, question_failed? || false) # rubocop:disable Rails/SkipsModelValidations
  end

  def question_failed?
    return true if failed_because_all_answers_selected?
    return failed_pass_if_any_selected? if passing_criteria == 'pass_if_any_selected'
    return failed_pass_if_all_selected? if passing_criteria == 'pass_if_all_selected'

    failed_fail_if_any_selected? if passing_criteria == 'fail_if_any_selected'
  end

  # rubocop:disable Metrics/MethodLength
  def self.generate_questions(survey)
    questions = []
    survey.prescreener_question_templates.active.each do |question_template|
      questions << {
        body: question_template.body,
        sort_order: question_template&.sort_order,
        question_type: question_template&.question_type,
        passing_criteria: question_template&.passing_criteria,
        prescreener_question_template_id: question_template.id,
        answer_options: question_template.prescreener_answer_templates.by_sort_order.pluck(:body),
        target_answers: question_template.prescreener_answer_templates.targets.pluck(:body)
      }
    end
    questions
  end
  # rubocop:enable Metrics/MethodLength

  private

  def failed_pass_if_any_selected?
    return if (selected_answers & target_answers).present?

    onboarding.record_screened_event
    true
  end

  def failed_pass_if_all_selected?
    return if target_answers.all? { |target| selected_answers.include?(target) }

    onboarding.record_screened_event
    true
  end

  def failed_fail_if_any_selected?
    return unless selected_answers.any? { |selected| target_answers.include?(selected) }

    onboarding.record_screened_event
    true
  end

  def failed_because_all_answers_selected?
    return unless selected_answers.sort == answer_options.sort
    return if question_type == 'open_end'

    onboarding.record_screened_event
    true
  end
end

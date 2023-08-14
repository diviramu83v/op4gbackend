# frozen_string_literal: true

class Survey::PrescreenerChecksController < Survey::BaseController
  before_action :load_onboarding_and_question

  def new; end

  # rubocop:disable Metrics/MethodLength
  def create
    if @prescreener_question.incomplete?
      case @prescreener_question.question_type
      when 'single_answer'
        handle_single_answer
      when 'multi_answer'
        handle_multi_answer
      when 'open_end'
        handle_open_end_answer
      end
      @prescreener_question.complete!
    end
    redirect_to next_screener_question_or_traffic_step
  end
  # rubocop:enable Metrics/MethodLength

  private

  def next_screener_question_or_traffic_step
    return new_survey_screener_step_question_url(@onboarding.next_prescreener_question.token) if @onboarding.next_prescreener_question&.token

    new_survey_step_check_url(@onboarding.next_traffic_step_or_analyze&.token)
  end

  def handle_single_answer
    @prescreener_question.update(selected_answers: [params.dig(:answer, :selected_answer)&.downcase])
  end

  def handle_multi_answer
    params.dig(:answer, :checked_answers)&.each do |answer|
      @prescreener_question.selected_answers << answer.downcase
    end
    @prescreener_question.save!
  end

  def handle_open_end_answer
    @prescreener_question.update!(selected_answers: [params.dig(:answer, :typed_answer)&.downcase])
  end

  def load_onboarding_and_question
    @prescreener_question = PrescreenerQuestion.find_by(token: params[:screener_step_token])
    return redirect_to survey_error_url if @prescreener_question.blank?

    @onboarding = @prescreener_question.onboarding
  end

  def analyzer
    @analyzer ||= TrafficAnalyzer.new(onboarding: @onboarding, test_mode: test_mode_on?, request: request)
  end

  def test_mode_on?
    return false if current_employee.nil?

    current_employee.test_mode_on?
  end
end

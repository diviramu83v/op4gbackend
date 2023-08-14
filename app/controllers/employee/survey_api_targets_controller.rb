# frozen_string_literal: true

class Employee::SurveyApiTargetsController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'

  before_action :build_survey_info

  def new
    @target = @survey.build_survey_api_target
  end

  def create
    @target = @survey.build_survey_api_target(survey_api_target_params)

    if @target.save
      redirect_to survey_api_target_url(@survey)
    else
      render :new
    end
  end

  def show
    @target = @survey.survey_api_target
  end

  def edit
    @target = @survey.survey_api_target
  end

  def update
    @target = @survey.survey_api_target

    if @target.update(survey_api_target_params)
      redirect_to survey_api_target_url(@survey)
    else
      render :edit
    end
  end

  private

  def build_survey_info
    @survey = Survey.find(params[:survey_id])
  end

  # rubocop:disable Metrics/MethodLength
  def survey_api_target_params
    all_params = params.require(:survey_api_target).permit(
      :min_age,
      :max_age,
      :payout,
      :status,
      :custom_option,
      countries: [],
      genders: [],
      states: [],
      education: [],
      employment: [],
      income: [],
      race: [],
      number_of_employees: [],
      job_title: [],
      decision_maker: []
    )

    reject_blank_params(all_params)
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
  def reject_blank_params(all_params)
    all_params[:countries]&.reject!(&:blank?)
    all_params[:genders]&.reject!(&:blank?)
    all_params[:states]&.reject!(&:blank?)
    all_params[:education]&.reject!(&:blank?)
    all_params[:employment]&.reject!(&:blank?)
    all_params[:income]&.reject!(&:blank?)
    all_params[:race]&.reject!(&:blank?)
    all_params[:number_of_employees]&.reject!(&:blank?)
    all_params[:job_title]&.reject!(&:blank?)
    all_params[:decision_maker]&.reject!(&:blank?)

    all_params
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
end

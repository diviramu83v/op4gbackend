# frozen_string_literal: true

class Employee::SchlesingerQuotasController < Employee::OperationsBaseController # rubocop:disable Metrics/ClassLength
  authorize_resource class: 'Survey'

  before_action :set_survey, except: [:edit, :update]
  before_action :industries, :study_types, :sample_types, :qualification_questions, only: [:new, :create, :edit, :update]

  def index
    @schlesinger_qualification_answers = SchlesingerQualificationAnswer.answers_hash
  end

  def new
    @schlesinger_quota = @survey.schlesinger_quotas.new
  end

  def edit
    @schlesinger_quota = SchlesingerQuota.find(params[:id])
    @survey = @schlesinger_quota.survey
  end

  def create
    CreateSchlesingerQuotaJob.perform_async(@survey.id, schlesinger_quota_params.to_json, clean_qualifications_params.to_json)

    flash[:notice] = 'Schlesinger quota is being created, it will show up here when it has been created.'
    redirect_to survey_schlesinger_quotas_url(@survey)
  end

  def update
    @schlesinger_quota = SchlesingerQuota.find(params[:id])
    @survey = @schlesinger_quota.survey
    @schlesinger_quota.qualifications = clean_qualifications_params
    if @schlesinger_quota.update(schlesinger_quota_params)
      flash[:notice] = 'Schlesinger quota updated successfully.'
      redirect_to survey_schlesinger_quotas_url(@survey)
    else
      render 'edit'
    end
  end

  private

  def qualification_questions
    @qualification_questions = SchlesingerQualificationQuestion.ordered_by_id
    @qualification_questions = @qualification_questions.preload(:qualification_answers)
  end

  def industries
    @industries = SchlesingerApi.new.industries
  end

  def study_types
    @study_types = SchlesingerApi.new.study_types
  end

  def sample_types
    @sample_types = SchlesingerApi.new.sample_types
  end

  def schlesinger_quota_params
    params.require(:schlesinger_quota).permit(:cpi, :loi, :soft_launch_completes_wanted, :completes_wanted, :conversion_rate, :industry_id,
                                              :study_type_id, :sample_type_id, :start_date_time, :end_date_time)
  end

  def clean_qualifications_params
    qualifications_params.to_h.each_with_object({}) do |array, hash|
      value = array.last.compact_blank
      next if value.blank?

      hash[array.first] = range_value(array) || value
    end
  end

  def range_value(array)
    return unless array.first == 'age'

    qualification_range(array)
  end

  def qualification_range(array)
    (array.last.values.first.to_i..array.last.values.last.to_i).to_a
  end

  def qualifications_params # rubocop:disable Metrics/MethodLength
    params.require(:schlesinger_quota).permit(
      qualifications: [
        age: [:min_age, :max_age],
        gender: [],
        standard_relationship: [],
        standard_education: [],
        standard_hhi_us: [],
        parental_status_standard: [],
        standard_pets: [],
        standard_industry_personal: [],
        standard_industry: [],
        standard_no_of_employees: [],
        standard_company_revenue: [],
        standard_company_department: [],
        standard_job_title: [],
        standard_b2b_decision_maker: [],
        standard_diagnosed_ailments_i: [],
        standard_diagnosed_ailments_ii: [],
        standard_sufferer_ailments_i: [],
        standard_sufferer_ailments_ii: [],
        standard_cancer_type: [],
        standard_diabetes_type: [],
        standard_hh_sufferer_ailments_i: [],
        standard_hh_sufferer_ailments_ii: [],
        standard_care_giver_i: [],
        standard_care_giver_ii: [],
        standard_hh_cancer: [],
        standard_employment: [],
        standard_sexual_orientation_en: [],
        ethnicity: [],
        hispanic: [],
        dma: [],
        state: [],
        region: [],
        military_status: [],
        itdm: [],
        professional_trades_hvac: [],
        investible_asset: [],
        fed_govt_emp_new: [],
        construction_trade: [],
        standard_supplemental_income: [],
        standard_organization_type: [],
        standard_industry_it: [],
        standard_industry_healthcare: [],
        standard_military_service: [],
        sample_cube_counties: [],
        standard_occupation: [],
        web_developers_2020: [] # rubocop:disable Naming/VariableNumber
      ]
    )[:qualifications]
  end

  def set_survey
    @survey = Survey.find(params[:survey_id])
  end
end

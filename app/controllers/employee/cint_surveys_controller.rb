# frozen_string_literal: true

class Employee::CintSurveysController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'

  before_action :set_survey, except: [:edit, :update]
  before_action :set_age_range, only: [:new, :create]
  before_action :build_country_options, only: [:new, :create]
  before_action :build_state_options, only: [:new, :create]
  before_action :build_city_options, only: [:new, :create]

  def index; end

  def new
    @cint_survey = @survey.cint_surveys.new
  end

  def edit
    @cint_survey = CintSurvey.find(params[:id])
    @survey = @cint_survey.survey
  end

  def create
    @cint_survey = @survey.cint_surveys.new(cint_survey_params)
    @cint_survey.variable_ids = reject_blank_values(cint_survey_options_params.to_h)
    if @cint_survey.save
      flash[:notice] = 'Cint survey saved successfully.'
      redirect_to survey_cint_surveys_url(@survey)
    else
      render 'new'
    end
  end

  def update
    @cint_survey = CintSurvey.find(params[:id])
    @survey = @cint_survey.survey

    if @cint_survey.update(cint_survey_params)
      flash[:notice] = 'Cint quota updated successfully.'

      redirect_to survey_cint_surveys_url(@survey)
    else
      render 'edit'
    end
  end

  private

  def build_country_options
    countries = CintApi.new.countries_hash
    @countries_options = []
    countries.each do |country|
      next unless country['name'] == 'USA'

      @countries_options.push([country['name'], country['id']])
    end
  end

  def build_state_options
    region_types = build_region_types
    @states = []
    region_types[0][4]['regions'].each do |state|
      @states.push({ name: state['name'], id: state['id'] })
    end
  end

  def build_city_options
    region_types = build_region_types
    @cities = []
    region_types[0][3]['regions'].each do |city|
      @cities.push({ name: city['name'], id: city['id'] })
    end
  end

  def build_region_types
    countries = CintApi.new.countries_hash
    region_types = []
    countries.each do |country|
      next unless country['name'] == 'USA'

      region_types.push(country['regionTypes'])
    end
    region_types
  end

  def set_age_range
    @age_range = 18..99
  end

  def set_survey
    @survey = Survey.find(params[:survey_id])
  end

  def cint_survey_params
    params.require(:cint_survey).permit(:loi, :limit, :cpi, :expected_incidence_rate, :name, :cint_country_id, :min_age, :max_age, :gender, :postal_codes,
                                        region_ids: [])
  end

  def cint_survey_options_params
    params.require(:options).permit!
  end

  def reject_blank_values(cint_survey_options_params)
    cint_survey_options_params&.to_h&.values&.flatten&.reject(&:blank?)
  end
end

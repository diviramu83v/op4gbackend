# frozen_string_literal: true

require 'test_helper'

class Employee::SurveysControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
    @survey = surveys(:standard)
  end

  describe '#show' do
    it 'should load the show page' do
      get survey_url(@survey)

      assert_response :ok
    end

    it 'should load the show page with an even amount of traffic' do
      2.times do
        onboarding = Onboarding.create(onramp: @survey.onramps.last, survey_response_pattern: survey_response_patterns(:complete))
        onboarding.record_onboarding_completion
        onboarding.record_survey_response(survey_response_urls(:complete))
      end
      get survey_url(@survey)

      assert_response :ok
    end

    it 'should load the show page with an odd amount of traffic' do
      onboarding = Onboarding.create(onramp: @survey.onramps.last, survey_response_pattern: survey_response_patterns(:complete))
      onboarding.record_onboarding_completion
      onboarding.record_survey_response(survey_response_urls(:complete))

      get survey_url(@survey)

      assert_response :ok
    end

    it 'should display the bad redirect traffic alert' do
      redirect_log = redirect_logs(:one)
      redirect_log.update!(created_at: Time.now.utc)
      @survey.project.responses << redirect_log.survey_response_url

      assert_equal @survey.project.redirect_logs.last, redirect_log

      get project_url(@survey.project)

      assert @survey.project.bad_redirect_last_twenty_four_hours?
      assert response.body.include? 'Bad redirect traffic detected in the last 24 hours.'
    end

    it 'should not display the bad redirect traffic alert' do
      redirect_log = redirect_logs(:one)
      redirect_log.update!(created_at: 3.days.ago)
      @survey.project.responses << redirect_log.survey_response_url

      assert_equal @survey.project.redirect_logs.last, redirect_log

      get project_url(@survey.project)

      assert_not @survey.project.bad_redirect_last_twenty_four_hours?
      assert_not response.body.include? 'Bad redirect traffic detected in the last 24 hours.'
    end
  end

  it 'should show edit survey page' do
    get edit_survey_url(@survey)

    assert_response :ok
  end

  describe '#create' do
    setup do
      sign_in employees(:operations)
      @project = projects(:standard)
    end

    it 'should create survey' do
      assert_difference -> { @project.surveys.count } do
        post project_surveys_url(@project)
      end
    end
  end

  it 'should update survey' do
    @url = 'http://test.com/new?id={{uid}}'

    put survey_url(@survey),
        params: { survey: { base_link: @url } },
        headers: @headers
    @survey.reload

    assert_equal @url, @survey.base_link
  end

  it 'should fail to update survey without {{uid}}' do
    @url = 'http://test.com/new'

    put survey_url(@survey),
        params: { survey: { base_link: @url } },
        headers: @headers
    @survey.reload

    assert_response_with_warning
  end

  it 'should fail to update survey without https://' do
    @url = 'test.com/new?id={{uid}}'

    put survey_url(@survey),
        params: { survey: { base_link: @url } },
        headers: @headers
    @survey.reload

    assert_response_with_warning
  end

  it 'should notify user when unable to update survey' do
    # Force failure.
    Survey.any_instance.stubs(:update).returns(false)

    put survey_url(@survey),
        params: { survey: { base_link: '' } },
        headers: @headers

    assert_not_nil flash[:alert]
  end

  it 'should remove survey' do
    @survey = new_survey
    @survey.project.add_survey

    assert_empty @survey.sample_batches

    assert_difference -> { Survey.count }, -1 do
      delete survey_url(@survey)
    end
  end

  it 'should notify user when unable to remove survey' do
    delete survey_url(@survey)

    assert_not_nil flash[:alert]
  end

  private

  # rubocop:disable Metrics/MethodLength
  def new_survey
    Survey.create(name: Faker::Company.name,
                  category: 'standard',
                  project: Project.create(
                    name: Faker::Company.name,
                    manager: Employee.create(
                      first_name: Faker::Name.first_name,
                      last_name: Faker::Name.last_name,
                      email: Faker::Internet.email,
                      password: Faker::Internet.password
                    )
                  ))
  end
  # rubocop:enable Metrics/MethodLength
end

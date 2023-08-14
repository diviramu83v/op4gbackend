# frozen_string_literal: true

require 'test_helper'

class SchlesingerApiTest < ActiveSupport::TestCase
  setup do
    @demand_url = Settings.schlesinger_demand_api_url
    @auth = { 'X-MC-DEMAND-KEY' => Settings.schlesinger_api_key, 'Content-Type' => 'application/json', 'Cache-Control' => 'no-cache', 'Accept' => 'text/json' }
  end

  describe '#create_project' do
    it 'creates a project without errors' do
      project_name = 'Test Project'
      project_description = 'Test Project Description'
      stub_request(:post, "#{@demand_url}/api/v1/project/create")
        .to_return(status: 200,
                   body: { projectName: project_name, projectDesc: project_description, projectId: 5678 }.to_json,
                   headers: @auth)

      response = SchlesingerApi.new.create_project(body: { project_name: project_name, project_description: project_description })

      assert_equal response, 5678
    end

    describe '#create survey' do
      it 'should create a survey without errors' do
        stub_request(:post, "#{@demand_url}/api/v1/survey/create")
          .to_return(status: 200,
                     body: { surveyName: 'Test Survey', countryLanguageID: 1, industryID: 1, studyTypeID: 1, clientCPI: 1, surveyLiveURL: 'http://www.test.com',
                             surveyTestURL: 'http://www.test.com', projectId: 1, quota: 1, quotaCalculationTypeID: 1, loi: 1, sampleTypeID: 1, ir: 1,
                             collectsPII: true, isDesktopAllowed: true, isMobileAllowed: true, isTabletAllowed: true, surveyStatusId: 1, surveyId: 1,
                             startDateTime: '2022-01-01', endDateTime: '2022-01-08' }.to_json,
                     headers: @auth)

        response = SchlesingerApi.new.create_survey(body: { surveyName: 'Test Survey', countryLanguageID: 1, industryID: 1, studyTypeID: 1, clientCPI: 1,
                                                            surveyLiveURL: 'http://www.test.com', surveyTestURL: 'http://www.test.com', projectId: 1, quota: 1,
                                                            quotaCalculationTypeID: 1, loi: 1, sampleTypeID: 1, ir: 1, collectsPII: true,
                                                            isDesktopAllowed: true, isMobileAllowed: true, isTabletAllowed: true, surveyStatusId: 1,
                                                            startDateTime: '2022-01-01', endDateTime: '2022-01-08' })

        assert_equal response, 1
      end
    end

    describe '#change_survey_status' do
      it 'should change the status of a survey without errors' do
        stub_request(:put, "#{@demand_url}/api/v1/survey/update-status")
          .to_return(status: 200,
                     body: { surveyId: 1, live_Url: 'http://www.test.com', surveyStatusId: 5, surveyName: 'Test survey' }.to_json,
                     headers: @auth)

        assert_nil SchlesingerApi.new.change_survey_status(body: { surveyId: 1, live_Url: 'http://www.test.com', surveyStatusId: 5, surveyName: 'Test survey' })
      end
    end

    describe '#update_survey' do
      it 'should update a survey without errors' do
        stub_request(:put, "#{@demand_url}/api/v1/survey/update")
          .to_return(status: 200,
                     body: { surveyId: 1, surveyName: 'Test Survey', countryLanguageID: 1, industryID: 1, studyTypeID: 1, clientCPI: 1,
                             surveyLiveURL: 'http://www.test.com', surveyTestURL: 'http://www.test.com', projectId: 1, quota: 1, quotaCalculationTypeID: 1,
                             loi: 1, sampleTypeID: 1, ir: 1, collectsPII: true, isDesktopAllowed: true, isMobileAllowed: true, isTabletAllowed: true,
                             surveyStatusId: 1, startDateTime: '2022-01-01', endDateTime: '2022-01-08' }.to_json,
                     headers: @auth)

        assert_nil SchlesingerApi.new.update_survey(body: { surveyId: 1, surveyName: 'Test Survey', countryLanguageID: 1, industryID: 1, studyTypeID: 1,
                                                            clientCPI: 1, surveyLiveURL: 'http://www.test.com', surveyTestURL: 'http://www.test.com',
                                                            projectId: 1, quota: 1, quotaCalculationTypeID: 1, loi: 1, sampleTypeID: 1, ir: 1,
                                                            collectsPII: true, isDesktopAllowed: true, isMobileAllowed: true, isTabletAllowed: true,
                                                            surveyStatusId: 1, startDateTime: '2022-01-01', endDateTime: '2022-01-08' })
      end
    end

    describe '#get_survey_status' do
      it 'should get the status of a survey without errors' do
        stub_request(:get, "#{@demand_url}/api/v1/survey/1")
          .to_return(status: 200,
                     body: { surveyName: 'Test Survey', countryLanguageID: 1, industryID: 1, studyTypeID: 1, clientCPI: 1, surveyLiveURL: 'http://www.test.com',
                             surveyTestURL: 'http://www.test.com', projectId: 1, quota: 1, quotaCalculationTypeID: 1, loi: 1, sampleTypeID: 1, ir: 1,
                             collectsPII: true, isDesktopAllowed: true, isMobileAllowed: true, isTabletAllowed: true, surveyStatusId: 1, surveyId: 1,
                             startDateTime: '2022-01-01', endDateTime: '2022-01-08' }.to_json,
                     headers: @auth)

        response = SchlesingerApi.new.get_survey_status(schlesinger_survey_id: 1)

        assert_equal response, 1
      end
    end

    describe '#get_survey_name' do
      it 'should get the name of a survey without errors' do
        stub_request(:get, "#{@demand_url}/api/v1/survey/1")
          .to_return(status: 200,
                     body: { surveyName: 'Test Survey', countryLanguageID: 1, industryID: 1, studyTypeID: 1, clientCPI: 1, surveyLiveURL: 'http://www.test.com',
                             surveyTestURL: 'http://www.test.com', projectId: 1, quota: 1, quotaCalculationTypeID: 1, loi: 1, sampleTypeID: 1, ir: 1,
                             collectsPII: true, isDesktopAllowed: true, isMobileAllowed: true, isTabletAllowed: true, surveyStatusId: 1, surveyId: 1,
                             startDateTime: '2022-01-01', endDateTime: '2022-01-08' }.to_json,
                     headers: @auth)

        response = SchlesingerApi.new.get_survey_name(schlesinger_survey_id: 1)

        assert_equal response, 'Test Survey'
      end
    end

    describe '#create_qualifications' do
      it 'should create qualifications without errors' do
        stub_request(:post, "#{@demand_url}/api/v1/qualification/create")
          .to_return(status: 200,
                     body: {
                       surveyId: 1,
                       qualifications: [
                         {
                           qualificationId: 59,
                           name: 'Age',
                           text: 'What is your age?',
                           qualificationCategoryId: 5,
                           qualificationTypeId: 6,
                           answers: %w[21 22]
                         }
                       ]
                     }.to_json,
                     headers: @auth)

        response = SchlesingerApi.new.create_qualifications(body: { surveyId: 1,
                                                                    qualifications: [
                                                                      {
                                                                        qualificationId: 59,
                                                                        name: 'Age',
                                                                        text: 'What is your age?',
                                                                        qualificationCategoryId: 5,
                                                                        qualificationTypeId: 6,
                                                                        answers: %w[21 22]
                                                                      }
                                                                    ] })

        assert_equal response.last['qualificationId'], 59
      end
    end

    describe '#update_qualifications' do
      it 'should update qualifications without errors' do
        stub_request(:put, "#{@demand_url}/api/v1/qualification/update")
          .to_return(status: 200,
                     body: {
                       surveyId: 1,
                       qualifications: [
                         {
                           qualificationId: 59,
                           name: 'Age',
                           text: 'What is your age?',
                           qualificationCategoryId: 5,
                           qualificationTypeId: 6,
                           answers: %w[21 22]
                         }
                       ]
                     }.to_json,
                     headers: @auth)

        assert_nil SchlesingerApi.new.update_qualifications(body: { surveyId: 1,
                                                                    qualifications: [
                                                                      {
                                                                        qualificationId: 59,
                                                                        name: 'Age',
                                                                        text: 'What is your age?',
                                                                        qualificationCategoryId: 5,
                                                                        qualificationTypeId: 6,
                                                                        answers: %w[21 22]
                                                                      }
                                                                    ] })
      end
    end

    describe '#delete_qualifications' do
      it 'should delete qualifications without errors' do
        stub_request(:delete, "#{@demand_url}/api/v1/qualification/delete")
          .to_return(status: 200,
                     body: { surveyId: 1, qualificationIds: [1, 2] }.to_json,
                     headers: @auth)

        assert_nil SchlesingerApi.new.delete_qualifications(body: { surveyId: 1, qualificationIds: [1, 2] })
      end
    end

    describe '#create_quota' do
      it 'should create a quota without errors' do
        stub_request(:post, "#{@demand_url}/api/v1/quota/create")
          .to_return(status: 200,
                     body: { surveyId: 1,
                             quotas: [{
                               surveyQuotaId: 3689,
                               name: 'Test Quota',
                               completesRequired: 10,
                               quotaCalculationType: 1,
                               conditions: [{
                                 qualificationId: 65,
                                 answers: %w[1 2 3]
                               }]
                             }] }.to_json,
                     headers: @auth)

        response = SchlesingerApi.new.create_quota(body: { surveyId: 1,
                                                           quotas: [{
                                                             name: 'Test Quota',
                                                             completesRequired: 10,
                                                             quotaCalculationType: 1,
                                                             conditions: [{
                                                               qualificationId: 65,
                                                               answers: %w[1 2 3]
                                                             }]
                                                           }] })

        assert_equal response, 3689
      end
    end

    describe '#update_quota' do
      it 'should update a quota without errors' do
        stub_request(:put, "#{@demand_url}/api/v1/quota/update")
          .to_return(status: 200,
                     body: { surveyId: 1,
                             quotas: [{
                               surveyQuotaId: 1,
                               name: 'name26',
                               completesRequired: 10,
                               quotaCalculationType: 2,
                               conditions: [{
                                 qualificationId: 65,
                                 answers: %w[1 2 3]
                               }]
                             }] }.to_json,
                     headers: @auth)

        assert_nil SchlesingerApi.new.update_quota(body: { surveyId: 1,
                                                           quotas: [{
                                                             surveyQuotaId: 1,
                                                             name: 'name26',
                                                             completesRequired: 10,
                                                             quotaCalculationType: 2,
                                                             conditions: [{
                                                               qualificationId: 65,
                                                               answers: %w[1 2 3]
                                                             }]
                                                           }] })
      end
    end

    describe '#delete_quota' do
      it 'should delete a quota without errors' do
        stub_request(:delete, "#{@demand_url}/api/v1/quota/delete")
          .to_return(status: 200,
                     body: { surveyId: 1, quotas: [1] }.to_json,
                     headers: @auth)

        assert_nil SchlesingerApi.new.delete_quota(body: { surveyId: 1, quotas: [1] })
      end
    end
  end
end

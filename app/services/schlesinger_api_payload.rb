# frozen_string_literal: true

# Returns the api body for schlesinger api calls
class SchlesingerApiPayload # rubocop:disable Metrics/ClassLength
  def initialize(schlesinger_object:)
    @schlesinger_object = schlesinger_object
  end

  def project_body
    {
      projectName: @schlesinger_object.survey.project.name,
      projectDesc: @schlesinger_object.survey.name
    }
  end

  def survey_body # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    {
      surveyName: "#{@schlesinger_object.survey.name} - #{@schlesinger_object.onramp.id}",
      countryLanguageID: 3, # Defaulting to 'US English'
      industryID: @schlesinger_object.industry_id,
      studyTypeID: @schlesinger_object.study_type_id,
      clientCPI: @schlesinger_object.cpi,
      surveyLiveURL: "https://survey.op4g.com/onramps/#{@schlesinger_object.onramp.token}?pid=[#scid#]",
      surveyTestURL: "https://survey.op4g.com/onramps/#{@schlesinger_object.onramp.token}?bypass=#{@schlesinger_object.onramp.bypass_token}&pid=[#scid#]",
      projectId: @schlesinger_object.schlesinger_project_id,
      quota: @schlesinger_object.completes_wanted,
      quotaCalculationTypeID: 1, # Defaulting to 'Completes'
      loi: @schlesinger_object.loi,
      sampleTypeID: @schlesinger_object.sample_type_id,
      ir: @schlesinger_object.conversion_rate,
      collectsPII: false,
      isDesktopAllowed: true,
      isMobileAllowed: true,
      isTabletAllowed: true,
      surveyStatusId: 1, # Defaulting to 'Awarded', the first status a survey has when the project is won and but not live in the field yet.
      startDateTime: @schlesinger_object.start_date_time.beginning_of_day.utc,
      endDateTime: @schlesinger_object.end_date_time.end_of_day.utc
    }
  end

  def change_survey_status_body(status)
    {
      surveyId: @schlesinger_object.schlesinger_survey_id,
      live_Url: "https://survey.op4g.com/onramps/#{@schlesinger_object.onramp.token}?pid=[#scid#]",
      surveyStatusId: SchlesingerQuota.status_id(status),
      surveyName: @schlesinger_object.name
    }
  end

  def update_survey_body # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    {
      surveyId: @schlesinger_object.schlesinger_survey_id,
      surveyName: @schlesinger_object.name,
      countryLanguageID: 3, # Defaulting to 'US English'
      industryID: @schlesinger_object.industry_id,
      studyTypeID: @schlesinger_object.study_type_id,
      clientCPI: @schlesinger_object.cpi,
      surveyLiveURL: "https://survey.op4g.com/onramps/#{@schlesinger_object.onramp.token}",
      surveyTestURL: "https://survey.op4g.com/onramps/#{@schlesinger_object.onramp.token}?bypass=#{@schlesinger_object.onramp.bypass_token}",
      projectId: @schlesinger_object.schlesinger_project_id,
      quota: @schlesinger_object.completes_wanted,
      quotaCalculationTypeID: 1, # Defaulting to 'Completes'
      loi: @schlesinger_object.loi,
      sampleTypeID: @schlesinger_object.sample_type_id,
      ir: @schlesinger_object.conversion_rate,
      collectsPII: false,
      isDesktopAllowed: true,
      isMobileAllowed: true,
      isTabletAllowed: true,
      surveyStatusId: SchlesingerQuota.status_id(@schlesinger_object.status.to_sym),
      startDateTime: @schlesinger_object.start_date_time.beginning_of_day.utc,
      endDateTime: @schlesinger_object.end_date_time.end_of_day.utc
    }
  end

  def qualifications_body
    {
      surveyId: @schlesinger_object.schlesinger_survey_id,
      qualifications: qualifications
    }
  end

  def qualifications
    @schlesinger_object.qualifications.map do |array|
      question = SchlesingerQualificationQuestion.find_by(slug: array.first)
      {
        qualificationId: question.qualification_id,
        name: question.name,
        answers: array.last
      }
    end
  end

  def delete_qualification_body(survey_qualification_id)
    {
      surveyId: @schlesinger_object.schlesinger_survey_id,
      qualificationIds: [survey_qualification_id]
    }
  end

  def quota_body
    {
      surveyId: @schlesinger_object.schlesinger_survey_id,
      quotas: [{
        name: @schlesinger_object.survey.name,
        completesRequired: @schlesinger_object.completes_wanted,
        quotaCalculationType: 1, # Defaulting to 'Completes'
        conditions: quota_conditions
      }]
    }
  end

  def quota_conditions
    return if @schlesinger_object.qualifications.blank?

    @schlesinger_object.qualifications.map do |array|
      question = SchlesingerQualificationQuestion.find_by(slug: array.first)
      {
        qualificationId: question.qualification_id,
        answers: array.last
      }
    end
  end

  def update_quota_body
    {
      surveyId: @schlesinger_object.schlesinger_survey_id,
      quotas: [{
        surveyQuotaId: @schlesinger_object.schlesinger_quota_id,
        name: @schlesinger_object.survey.name,
        completesRequired: @schlesinger_object.completes_wanted,
        quotaCalculationType: 1, # Defaulting to 'Completes'
        conditions: quota_conditions
      }]
    }
  end

  def delete_quota_body(schlesinger_quota_id)
    {
      surveyId: @schlesinger_object.schlesinger_survey_id,
      quotas: [schlesinger_quota_id]
    }
  end
end

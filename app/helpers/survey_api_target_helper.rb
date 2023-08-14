# frozen_string_literal: true

# View helpers for survey api target.
module SurveyApiTargetHelper
  def formatted_age_range(api_survey_target)
    if api_survey_target.min_age > SurveyApiTarget::MIN_AGE && api_survey_target.max_age < SurveyApiTarget::MAX_AGE
      return "#{api_survey_target.min_age} - #{api_survey_target.max_age}"
    end
    return "#{api_survey_target.min_age} +" if api_survey_target.max_age == SurveyApiTarget::MAX_AGE

    "< #{api_survey_target.max_age}"
  end
end

# frozen_string_literal: true

# View helpers for survey pages and cards.
module SurveyHelper
  def survey_panelist_url(survey, panelist)
    survey.base_link + "?uid=#{panelist.survey_token(survey)}"
  end

  def test_survey_panelist_url(survey, panelist)
    test_invitation_url(panelist.survey_token(survey))
  end

  def survey_initial_count(survey)
    return if survey.complete_count == survey.adjusted_complete_count

    "(#{survey.complete_count} initial)"
  end

  def api_status_class(survey_api_target)
    return 'primary' if survey_api_target&.active?

    'secondary'
  end

  def survey_project_name(survey)
    if survey.name == 'Survey'
      survey.project.name
    else
      "#{survey.project.name} / #{survey.name}"
    end
  end

  def waiting_for_ids_label(status)
    status == 'waiting' ? 'waiting for IDs' : status
  end
end

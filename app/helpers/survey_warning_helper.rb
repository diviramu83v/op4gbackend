# frozen_string_literal: true

# View helpers for survey warnings.
module SurveyWarningHelper
  # rubocop:disable Metrics/MethodLength
  def survey_warning_message(warning)
    survey = warning.survey
    survey_name = survey_project_name(survey)

    content = []

    case warning.category
    when 'query_has_no_filters'
      query = warning.sample_batch.query
      content << link_to(survey_name, survey_queries_url(survey, anchor: "query-#{query.id}"))
      content << ' has queries with no filters.'
    when 'unsent_batches'
      content << link_to(survey_name, survey_queries_url(survey))
      content << ' has no sent panel invitations.'
    end

    safe_join(content)
  end
  # rubocop:enable Metrics/MethodLength
end

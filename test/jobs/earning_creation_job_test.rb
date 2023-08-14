# frozen_string_literal: true

require 'test_helper'

class EarningCreationJobTest < ActiveJob::TestCase
  before do
    survey = setup_live_survey
    @project = survey.project

    panelist = panelists(:active)
    invitation = project_invitations(:standard)
    invitation.update!(panelist: panelist, project: @project, survey: survey)

    onramp = onramps(:panel)
    onramp.update!(survey: survey, project: @project)
    @onboarding = onboardings(:standard)
    @onboarding.update!(panelist: panelist, project_invitation: invitation, onramp: onramp)
  end

  it 'earning created when job runs' do
    assert_difference -> { Earning.count }, 1 do
      EarningCreationJob.perform_now @onboarding
    end
  end

  it 'only one earning created if run more than once' do
    assert_difference -> { Earning.count }, 1 do
      EarningCreationJob.perform_now @onboarding
      EarningCreationJob.perform_now @onboarding
    end
  end
end

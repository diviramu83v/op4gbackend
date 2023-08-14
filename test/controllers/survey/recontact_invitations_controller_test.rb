# frozen_string_literal: true

require 'test_helper'

class Survey::RecontactInvitationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @recontact_invitation_batch = recontact_invitation_batches(:standard)
    @survey = @recontact_invitation_batch.survey
    @survey.update!(category: :recontact)
    @onboarding = onboardings(:standard)
    @onboarding.onramp.update!(category: :recontact)
    @recontact_invitation = @recontact_invitation_batch.create_invitation(@onboarding.token, 'https://www.test.com/{{uid}}/{{old_uid}}')
    @onramp = @survey.onramp_for_recontact(@survey)
  end

  describe '#show' do
    it 'redirects to client link' do
      get survey_recontact_invitation_url(@recontact_invitation.token)

      assert_redirected_to survey_onramp_url(@onramp.token, uid: @recontact_invitation.token)
    end

    # rubocop:disable Rails/SkipsModelValidations
    it 'redirects to recontact_error_errors and flashes alert when missing a survey' do
      @recontact_invitation_batch.update_columns(survey_id: nil)

      get survey_recontact_invitation_url(@recontact_invitation.token)

      assert_redirected_to survey_recontact_invitation_errors_url
      assert_equal 'Survey error. Please try again.', flash[:alert]
    end
    # rubocop:enable Rails/SkipsModelValidations

    it 'redirects to recontact_error_errors and flashes alert when missing recontact onramp' do
      @onramp.update!(category: :testing)

      get survey_recontact_invitation_url(@recontact_invitation.token)

      assert_redirected_to survey_recontact_invitation_errors_url
      assert_equal 'Survey error. Please try again.', flash[:alert]
    end
  end
end

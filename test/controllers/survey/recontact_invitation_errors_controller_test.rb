# frozen_string_literal: true

require 'test_helper'

class Survey::RecontactInvitationErrorsControllerTest < ActionDispatch::IntegrationTest
  it 'loads the errors page' do
    get survey_recontact_invitation_errors_url

    assert_response :ok
  end
end

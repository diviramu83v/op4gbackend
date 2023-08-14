# frozen_string_literal: true

require 'test_helper'

class Survey::ClientSentSurveysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @onramp = onramps(:client_sent)
  end
  it 'loads the page' do
    get survey_client_sent_survey_url(@onramp.token)

    assert_ok_with_no_warning
  end

  it 'loads the page' do
    get survey_client_sent_survey_url('notavalidtoken')

    assert_redirected_to survey_error_url
  end
end

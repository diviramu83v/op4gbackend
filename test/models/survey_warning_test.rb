# frozen_string_literal: true

require 'test_helper'

describe SurveyWarning do
  setup do
    @survey_warning = survey_warnings(:one)
  end

  test 'validity' do
    assert @survey_warning.valid?
  end
end

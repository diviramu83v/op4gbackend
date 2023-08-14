# frozen_string_literal: true

require 'test_helper'

class Employee::SurveyCpisControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
  end

  it 'update a survey cpi via the inline form' do
    @survey = surveys(:standard)
    patch survey_cpi_url(@survey), params: { survey: { cpi: 10 } }, xhr: true

    assert_ok_with_no_warning
  end

  it 'should display correct survey cpi link' do
    @survey = surveys(:standard)

    assert_equal "/surveys/#{@survey.id}/cpi", survey_cpi_path(@survey)
  end
end

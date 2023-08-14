# frozen_string_literal: true

require 'test_helper'

class Employee::RecruitmentSourceReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:admin)
  end

  describe '#new' do
    it 'should load the new page' do
      get new_recruitment_source_report_url
      assert_response :ok
    end
  end

  describe '#show' do
    it 'should load the show page' do
      get recruitment_source_report_url
      assert_response :ok
    end
  end
end

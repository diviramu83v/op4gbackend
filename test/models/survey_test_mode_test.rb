# frozen_string_literal: true

require 'test_helper'

class SurveyTestModeTest < ActiveSupport::TestCase
  describe '#easy_mode?' do
    describe 'easy test is set to true' do
      setup do
        @employee = employees(:operations)
        @employee.survey_test_mode.update!(easy_test: true)
      end

      it 'should return true' do
        assert @employee.survey_test_mode.easy_mode?
      end
    end

    describe 'easy test is set to false' do
      setup do
        @employee = employees(:operations)
      end

      it 'should return true' do
        assert_not @employee.survey_test_mode.easy_mode?
      end
    end
  end
end

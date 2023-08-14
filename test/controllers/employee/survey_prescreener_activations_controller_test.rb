# frozen_string_literal: true

require 'test_helper'

class Employee::SurveyPrescreenerActivationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_operations_employee
    @onramp = onramps(:testing)
    @survey = @onramp.survey
  end

  describe '#create (async)' do
    setup do
      assert_equal false, @onramp.check_prescreener
    end

    describe 'success' do
      it 'updates prescreener flag' do
        assert_changes '@onramp.check_prescreener', from: false, to: true do
          post "#{survey_prescreener_url(@survey)}.js"
          @onramp.reload
        end
        assert_response :ok
      end
    end

    describe 'failure' do
      setup do
        Onramp.any_instance.expects(:update!).raises(ActiveRecord::RecordInvalid).once
      end

      it 'does not update prescreener flag' do
        assert_no_changes '@onramp.check_prescreener' do
          post "#{survey_prescreener_url(@survey)}.js"
          @onramp.reload
        end
        assert_response :ok
      end

      it 'does not update prescreener flag because there are no prescreener questions' do
        @survey.prescreener_question_templates = []
        assert_no_changes '@onramp.check_prescreener' do
          post "#{survey_prescreener_url(@survey)}.js"
          @onramp.reload
        end
        assert_response :ok
      end
    end
  end

  describe '#destroy (async)' do
    setup do
      @onramp.update!(check_prescreener: true)
    end

    describe 'success' do
      it 'updates prescreener flag' do
        assert_changes '@onramp.check_prescreener', from: true, to: false do
          delete "#{survey_prescreener_url(@survey)}.js"
          @onramp.reload
        end
        assert_response :ok
      end
    end

    describe 'failure' do
      setup do
        Onramp.any_instance.expects(:update!).raises(ActiveRecord::RecordInvalid).once
      end

      it 'does not update prescreener flag' do
        assert_no_changes '@onramp.check_prescreener' do
          delete "#{survey_prescreener_url(@survey)}.js"
          @onramp.reload
        end
        assert_response :ok
      end
    end
  end
end

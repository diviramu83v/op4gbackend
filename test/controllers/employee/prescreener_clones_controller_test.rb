# frozen_string_literal: true

require 'test_helper'

class Employee::PrescreenerClonesControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_admin
    @survey = surveys(:second)
    @survey_to_clone = surveys(:standard)
  end

  describe '#show' do
    it 'should load the page' do
      get survey_prescreener_clones_url(@survey)

      assert_response :ok
    end

    describe '#search' do
      it 'should find the prescreener by project id' do
        get survey_prescreener_clones_url(@survey), params: { prescreener_clone_search: { id_or_keyword: '284678023' } }

        assert_response :ok
        assert_nil flash[:alert]
      end

      it 'should refresh the page and flash an alert if no prescreeners are found by the project id' do
        get survey_prescreener_clones_url(@survey), params: { prescreener_clone_search: { id_or_keyword: '123456789' } }

        assert_equal 'Prescreener(s) not found for project id or keyword(s): 123456789', flash[:alert]
        assert_redirected_to survey_prescreener_clones_url
      end

      it 'should find the prescreener by keyword' do
        get survey_prescreener_clones_url(@survey), params: { prescreener_clone_search: { id_or_keyword: 'well' } }

        assert_response :ok
        assert_nil flash[:alert]
      end

      it 'should refresh the page and flash an alert if no prescreeners are found by the keyword' do
        get survey_prescreener_clones_url(@survey), params: { prescreener_clone_search: { id_or_keyword: 'test' } }

        assert_equal 'Prescreener(s) not found for project id or keyword(s): test', flash[:alert]
        assert_redirected_to survey_prescreener_clones_url
      end
    end
  end

  describe '#create' do
    it 'should clone a prescreener question template' do
      assert_difference -> { @survey.prescreener_question_templates.count } do
        post survey_prescreener_clones_url(@survey), params: { survey_to_clone: @survey_to_clone.id }
      end
    end

    it 'should clone two prescreener answer templates' do
      assert_difference -> { PrescreenerAnswerTemplate.count }, 2 do
        post survey_prescreener_clones_url(@survey), params: { survey_to_clone: @survey_to_clone.id }
      end

      assert_equal PrescreenerAnswerTemplate.last.prescreener_question_template_id, @survey.prescreener_question_templates.last.id
    end
  end
end

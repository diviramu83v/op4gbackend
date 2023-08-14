# frozen_string_literal: true

require 'test_helper'

class Employee::PrescreenerAnswerTemplatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_admin
    @survey = surveys(:standard)
    @prescreener_question_template = prescreener_question_templates(:standard)
  end

  describe '#index' do
    it 'should load the page' do
      get prescreener_question_answers_url(@prescreener_question_template)

      assert_response :ok
    end
  end

  describe '#new' do
    it 'should load the page' do
      get new_prescreener_question_answer_url(@prescreener_question_template)

      assert_response :ok
    end
  end

  describe '#edit' do
    it 'should load the page' do
      @prescreener_answer_template = prescreener_answer_templates(:yes_answer)
      get edit_answer_url(@prescreener_answer_template)

      assert_response :ok
    end
  end

  describe '#create' do
    setup do
      @params = {
        prescreener_answer_template: {
          body: 'yes',
          target: false
        }
      }

      csv_rows = <<~HEREDOC
        yes
        no
      HEREDOC
      @file = Tempfile.new('answers.csv')
      @file.write(csv_rows)
      @file.rewind
    end

    describe 'manual' do
      it 'should create a prescreener answer manually' do
        assert_difference -> { @prescreener_question_template.prescreener_answer_templates.count } do
          post prescreener_question_answers_url(@prescreener_question_template), params: @params
        end
      end

      it 'should create a prescreener answer and redirect to the new answer page' do
        params = @params.merge(add_another: true)

        assert_difference -> { @prescreener_question_template.prescreener_answer_templates.count } do
          post prescreener_question_answers_url(@prescreener_question_template), params: params
        end
        assert_redirected_to new_prescreener_question_answer_url(@prescreener_question_template)
      end

      it 'should fail to create prescreener answer' do
        @params = {
          prescreener_answer_template: {
            body: nil,
            target: false
          }
        }

        assert_no_difference -> { @prescreener_question_template.prescreener_answer_templates.count } do
          post prescreener_question_answers_url(@prescreener_question_template), params: @params
        end
      end
    end
  end

  describe '#update' do
    setup do
      @prescreener_answer_template = prescreener_answer_templates(:yes_answer)
      @good_params = {
        prescreener_answer_template: {
          body: 'no',
          target: false
        }
      }
      @bad_params = {
        prescreener_answer_template: {
          body: ''
        }
      }
    end
    it 'should update answer' do
      put answer_url(@prescreener_answer_template),
          params: @good_params
      @prescreener_answer_template.reload

      assert_equal 'no', @prescreener_answer_template.body
    end

    it 'should not update answer and render edit' do
      put answer_url(@prescreener_answer_template),
          params: @bad_params

      assert_template :edit
    end
  end

  describe '#destroy' do
    setup do
      @prescreener_answer_template = prescreener_answer_templates(:no_answer)
    end

    it 'should delete all answers' do
      assert_not_empty @prescreener_question_template.prescreener_answer_templates
      assert_enqueued_with(job: DestroyAllPrescreenerAnswerTemplatesJob) do
        delete prescreener_question_all_answers_url(@prescreener_question_template, delete_all: true)
      end
    end

    it 'should delete the selected answer' do
      assert_difference -> { @prescreener_question_template.prescreener_answer_templates.count }, -1 do
        delete answer_url(@prescreener_answer_template)
      end
    end
  end
end

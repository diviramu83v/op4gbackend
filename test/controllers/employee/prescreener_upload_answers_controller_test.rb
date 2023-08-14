# frozen_string_literal: true

require 'test_helper'

# This tests the Prescreener Upload Answers Controller
class Employee::PrescreenerUploadAnswersControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    load_and_sign_in_admin
    @survey = surveys(:standard)
    @prescreener_question_template = prescreener_question_templates(:standard)
  end

  describe '#new' do
    test 'the page loads' do
      get new_prescreener_question_prescreener_upload_answer_url(@prescreener_question_template)

      assert_response :ok
    end
  end

  describe 'file upload' do
    setup do
      csv_rows = <<-HEREDOC
        yes
        no
      HEREDOC
      @file = Tempfile.new('answers.csv')
      @file.write(csv_rows)
      @file.rewind

      @params = {
        prescreener_answer_template: {
          body: 'yes',
          target: false
        },
        upload: {
          answer_upload: Rack::Test::UploadedFile.new(@file, 'text/csv')
        }
      }
    end

    test 'success' do
      assert_enqueued_with(job: UploadPrescreenerAnswerTemplatesJob) do
        post prescreener_question_prescreener_upload_answers_url(@prescreener_question_template), params: @params
      end
      assert_redirected_to prescreener_question_answers_url(@prescreener_question_template)
    end

    test 'failure' do
      @params = {
        upload: {
          upload_tool: true
        }
      }

      assert_no_difference -> { @prescreener_question_template.prescreener_answer_templates.count } do
        post prescreener_question_prescreener_upload_answers_url(@prescreener_question_template), params: @params
      end
    end

    test 'CSV::MalformedCSVError' do
      CSV.expects(:foreach).raises(CSV::MalformedCSVError.new('csv is malformed', 'line 15'))

      post prescreener_question_prescreener_upload_answers_url(@prescreener_question_template), params: @params
      assert_not_nil flash[:alert]
      assert_redirected_to new_prescreener_question_prescreener_upload_answer_url(@prescreener_question_template)
    end
  end
end

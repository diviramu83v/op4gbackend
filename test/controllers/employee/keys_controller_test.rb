# frozen_string_literal: true

require 'test_helper'

class Employee::KeysControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    sign_in employees(:operations)
    @survey = surveys(:standard)
  end

  describe '#index' do
    it 'should view keys' do
      get survey_keys_url(@survey, format: :html)

      assert_response :ok
    end

    it 'should download a csv of keys' do
      get survey_keys_url(@survey, format: :csv)

      assert_equal controller.headers['Content-Transfer-Encoding'], 'binary'
    end
  end

  describe '#new' do
    it 'should load the new page' do
      get new_survey_key_url(@survey)

      assert_response :ok
    end
  end

  describe '#create' do
    setup do
      csv_rows = <<~HEREDOC
        1
        2
      HEREDOC
      @file = Tempfile.new('keys.csv')
      @file.write(csv_rows)
      @file.rewind

      @malformed_csv_rows = <<~HEREDOC
        "1
        2
      HEREDOC
      @malformed_file = Tempfile.new('malformed_keys.csv')
      @malformed_file.write(@malformed_csv_rows)
      @malformed_file.rewind
    end

    it 'should add keys and start job' do
      params = {
        keys: {
          upload: Rack::Test::UploadedFile.new(@file, 'text/csv')
        }
      }
      assert_enqueued_jobs 1 do
        post survey_keys_url(@survey), params: params
      end
    end

    it 'should not start job and flash alert that job is already in progress' do
      @survey.temporary_keys = ['live']
      @survey.save
      params = {
        keys: {
          upload: Rack::Test::UploadedFile.new(@file, 'text/csv')
        }
      }
      assert_enqueued_jobs 0 do
        post survey_keys_url(@survey), params: params
      end
      assert_not_nil flash[:alert]
    end

    it 'should start job and flash alert that there are no keys' do
      @file = Tempfile.new('keys.csv')
      @file.rewind
      params = {
        keys: {
          upload: Rack::Test::UploadedFile.new(@file, 'text/csv')
        }
      }
      assert_enqueued_jobs 1 do
        post survey_keys_url(@survey), params: params
      end
      assert_not_nil flash[:alert]
    end

    it 'should fail due to missing upload parameter' do
      params = { keys: {} }
      assert_enqueued_jobs 0 do
        post survey_keys_url(@survey), params: params
      end
      assert_not_nil flash[:alert]
    end

    it 'should fail due to a malformed csv' do
      params = {
        keys: {
          upload: Rack::Test::UploadedFile.new(@malformed_file, 'text/csv')
        }
      }
      assert_enqueued_jobs 0 do
        post survey_keys_url(@survey), params: params
      end
      assert_not_nil flash[:alert]
    end
  end

  describe '#destroy' do
    setup do
      @key = keys(:standard)
      @key.update(project_id: @survey.project.id, survey_id: @survey.id)
    end

    it 'should destroy the key' do
      assert_difference -> { @survey.keys.count }, -1 do
        delete key_url(@key)
      end
    end
  end
end

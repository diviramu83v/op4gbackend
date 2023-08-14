# frozen_string_literal: true

require 'test_helper'

class Employee::RejectedCompletesControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_employee(:operations)
    @project = Project.first
  end

  describe '#new' do
    it 'should load the page' do
      get new_project_rejected_complete_url(@project)

      assert_response :ok
    end
  end

  describe '#show' do
    setup do
      @decoding = completes_decoders(:standard)
    end

    it 'should load the page' do
      get project_rejected_complete_url(@project, @decoding)

      assert_response :ok
    end
  end

  describe '#create' do
    describe 'success' do
      it 'should create a decoding with uids not from this project' do
        assert_difference -> { CompletesDecoder.count } do
          post project_rejected_completes_url(@project), params: { rejected_completes: { encoded_uids: 'asdfasdf' } }
        end
      end

      it 'should create a decoding with uids from this project' do
        assert_difference -> { CompletesDecoder.count } do
          post project_rejected_completes_url(@project), params: { rejected_completes: { encoded_uids: "xyz\nabc" } }
        end
        @project.reload
      end

      describe 'close-out process' do
        setup do
          csv_rows = <<~HEREDOC
            UID,Reason
            abcd,it's bad
            xyz,also bad
          HEREDOC
          @file = Tempfile.new('test_data.csv')
          @file.write(csv_rows)
          @file.rewind
        end
        it 'should redirect to the decoding page' do
          post project_rejected_completes_url(@project), params: { rejected_completes: { encoded_uids: Rack::Test::UploadedFile.new(@file, 'text/csv') } }

          assert_redirected_to project_rejected_complete_url(@project, CompletesDecoder.last)
        end
      end
    end

    describe 'failure' do
      it 'should fail to create a decoding' do
        assert_no_difference -> { CompletesDecoder.count } do
          post project_rejected_completes_url(@project), params: { rejected_completes: { encoded_uids: nil } }
        end
      end

      it 'should flash alert if no upload file' do
        post project_rejected_completes_url(@project), params: { rejected_completes: nil }
        assert_equal 'No upload file selected.', flash[:alert]
      end
    end
  end

  describe '#destroy' do
    setup do
      @decoding = completes_decoders(:standard)
    end

    it 'should destroy a decoding' do
      assert_difference -> { CompletesDecoder.count }, -1 do
        delete project_rejected_complete_url(@project, @decoding)
      end
    end
  end
end

# frozen_string_literal: true

require 'test_helper'

class Employee::CompletesControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_employee(:operations)
    @project = Project.first
  end

  describe '#new' do
    it 'should load the page' do
      get new_project_accepted_complete_url(@project)

      assert_response :ok
    end
  end

  describe '#show' do
    setup do
      @decoding = completes_decoders(:standard)
      @source = vendors(:batch)
    end

    it 'should load the page' do
      get project_accepted_complete_url(@project, @decoding)

      assert_response :ok
    end
  end

  describe '#create' do
    describe 'success' do
      it 'should create a decoding with uids not from this project' do
        assert_difference -> { CompletesDecoder.count } do
          post project_accepted_completes_url(@project), params: { accepted_completes: { encoded_uids: 'asdfasdf' } }
        end
      end

      it 'should create a decoding with uids from this project' do
        assert_difference -> { CompletesDecoder.count } do
          post project_accepted_completes_url(@project), params: { accepted_completes: { encoded_uids: "xyz\nabc" } }
        end

        @project.reload

        assert_redirected_to project_accepted_complete_url(@project, CompletesDecoder.last)
      end
    end

    describe 'failure' do
      it 'should fail to create a decoding' do
        assert_no_difference -> { CompletesDecoder.count } do
          post project_accepted_completes_url(@project), params: { accepted_completes: { encoded_uids: nil } }
        end
      end
    end
  end

  describe '#destroy' do
    setup do
      @decoding = completes_decoders(:standard)
    end

    it 'should destroy a decoding' do
      assert_difference -> { CompletesDecoder.count }, -1 do
        delete project_accepted_complete_url(@project, @decoding)
      end
    end
  end
end

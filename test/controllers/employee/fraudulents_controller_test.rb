# frozen_string_literal: true

require 'test_helper'

class Employee::FraudulentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_employee(:operations)
    @project = Project.first
  end

  describe '#new' do
    it 'should load the page' do
      get new_project_fraudulent_url(@project)

      assert_response :ok
    end
  end

  describe '#show' do
    setup do
      @decoding = completes_decoders(:standard)
    end

    it 'should load the page' do
      get project_fraudulent_url(@project, @decoding)

      assert_response :ok
    end
  end

  describe '#create' do
    describe 'success' do
      it 'should create a decoding with uids not from this project' do
        assert_difference -> { CompletesDecoder.count } do
          post project_fraudulents_url(@project), params: { fraudulents: { encoded_uids: 'asdfasdf' } }
        end
      end

      it 'should create a decoding with uids from this project' do
        assert_difference -> { CompletesDecoder.count } do
          post project_fraudulents_url(@project), params: { fraudulents: { encoded_uids: "xyz\nabc" } }
        end
        @project.reload
      end

      describe 'close-out process' do
        it 'should redirect to the decoding page' do
          post project_fraudulents_url(@project), params: { fraudulents: { encoded_uids: "xyz\nabc" } }

          assert_redirected_to project_fraudulent_url(@project, CompletesDecoder.last)
        end
      end
    end

    describe 'failure' do
      it 'should fail to create a decoding' do
        assert_no_difference -> { CompletesDecoder.count } do
          post project_fraudulents_url(@project), params: { fraudulents: { encoded_uids: nil } }
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
        delete project_fraudulent_url(@project, @decoding)
      end
    end
  end
end

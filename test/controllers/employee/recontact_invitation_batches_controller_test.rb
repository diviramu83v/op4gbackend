# frozen_string_literal: true

require 'test_helper'

class Employee::RecontactInvitationBatchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_employee(:admin)
    @recontact = surveys(:standard)
    @recontact.update!(category: :recontact)
  end

  describe '#new' do
    it 'should load the page' do
      get new_recontact_invitation_batch_url(@recontact)

      assert_response :ok
    end
  end

  describe '#edit' do
    it 'should load the page' do
      get edit_recontact_invitation_batch_url(@recontact)

      assert_response :ok
    end
  end

  describe '#create' do
    setup do
      csv_rows = <<~HEREDOC
        "xyz","https://www.testing.com/{{uid}}/{{old_uid}}"
      HEREDOC
      @file = Tempfile.new('test_data.csv')
      @file.write(csv_rows)
      @file.rewind
    end

    it 'should create a recontact invitation batch' do
      params = {
        recontact_invitation_batch: {
          uids_urls: Rack::Test::UploadedFile.new(@file, 'text/csv')
        }
      }

      assert_difference -> { RecontactInvitationBatch.count } do
        post recontact_invitation_batches_url(@recontact), params: params
      end
    end
  end

  describe '#update' do
    setup do
      @batch = recontact_invitation_batches(:standard)
      @params = { recontact_invitation_batch: { subject: 'new subject' } }
    end

    test 'redirection on update success' do
      put recontact_invitation_batch_url(@batch), params: @params

      assert_redirected_to recontact_url(@batch.survey)
    end

    test 'renders edit page on failure' do
      RecontactInvitationBatch.any_instance.expects(:update).returns(false).once
      put recontact_invitation_batch_url(@batch), params: @params
      assert_template :edit
    end
  end
end

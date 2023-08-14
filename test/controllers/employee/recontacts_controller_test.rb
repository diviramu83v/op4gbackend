# frozen_string_literal: true

require 'test_helper'

class Employee::RecontactsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_employee(:admin)
    @recontact = surveys(:standard)
    @recontact.update!(category: :recontact)
    @project = @recontact.project
  end

  describe '#show' do
    setup do
      @batch = recontact_invitation_batches(:standard)
      @batch.recontact_invitations.delete_all
      @batch.update!(status: :initialized)
    end

    it 'should load the page' do
      get recontact_url(@recontact)

      assert_response :ok
    end

    it 'should flash no email addresses found' do
      get recontact_url(@recontact, batch_id: @batch)

      assert_equal 'No email addresses found.', flash[:alert]
    end
  end

  describe '#edit' do
    it 'should load the page' do
      get edit_recontact_url(@recontact)

      assert_response :ok
    end
  end

  describe '#create' do
    it 'should create a recontact' do
      assert_difference -> { Survey.recontact.count } do
        post project_recontacts_url(@project)
      end
    end
  end

  it 'should update recontact' do
    @url = 'http://test.com/new?id={{uid}}'

    put recontact_url(@recontact),
        params: { survey: { base_link: @url } },
        headers: @headers
    @recontact.reload

    assert_equal @url, @recontact.base_link
  end

  it 'should not update recontact and render edit' do
    @url = 'http://test.com/new?id={{uid}}'

    put recontact_url(@recontact),
        params: { survey: { base_link: 'notvalid' } },
        headers: @headers
    @recontact.reload

    assert_template :edit
  end
end

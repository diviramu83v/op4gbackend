# frozen_string_literal: true

require 'test_helper'

class DisqoApiTest < ActiveSupport::TestCase
  setup do
    @quota = disqo_quotas(:standard)
    @url = Settings.disqo_api_url
    @client_id = Settings.disqo_username
  end

  describe '#create_project' do
    it 'creates a project without errors' do
      stub_request(:post, "#{@url}/v1/clients/#{@client_id}/projects")
        .to_return(status: 200,
                   body: '',
                   headers: { 'Content-Type' => 'application/json' })
      assert_nil DisqoApi.new.create_project(body: {})
    end

    it 'fails to create a project' do
      Rails.logger.expects(:error)
      stub_request(:post, "#{@url}/v1/clients/#{@client_id}/projects")
        .to_return(status: 409,
                   body: error_response_body.to_json,
                   headers: { 'Content-Type' => 'application/json' })
      DisqoApi.new.create_project(body: {})
    end
  end

  describe '#update_project' do
    it 'should update a project without errors' do
      stub_request(:put, "#{@url}/v1/clients/#{@client_id}/projects/1")
        .to_return(status: 200,
                   body: '',
                   headers: { 'Content-Type' => 'application/json' })
      assert_nil DisqoApi.new.update_project(project_id: 1, body: {})
    end
  end

  describe '#update_project_status' do
    it 'should update the project status without errors' do
      stub_request(:put, "#{@url}/v1/clients/#{@client_id}/projects/1/status")
        .to_return(status: 200,
                   body: '',
                   headers: { 'Content-Type' => 'application/json' })
      assert_nil DisqoApi.new.update_project_status(project_id: 1, status: 'OPEN')
    end
  end

  describe '#create_project_quota' do
    it 'creates a quota for a project' do
      stub_request(:post, "#{@url}/v1/clients/#{@client_id}/projects/1/quotas")
        .to_return(status: 200,
                   body: '',
                   headers: { 'Content-Type' => 'application/json' })
      assert_nil DisqoApi.new.create_project_quota(project_id: 1, body: {})
    end

    describe '#update_project_quota' do
      it 'updates a quota for a project' do
        stub_request(:put, "#{@url}/v1/clients/#{@client_id}/projects/1/quotas/1")
          .to_return(status: 200,
                     body: '',
                     headers: { 'Content-Type' => 'application/json' })
        assert_nil DisqoApi.new.update_project_quota(project_id: 1, quota_id: 1, body: {})
      end
    end

    it 'fails to create a quota for a project' do
      Rails.logger.expects(:error)
      stub_request(:post, "#{@url}/v1/clients/#{@client_id}/projects/1/quotas")
        .to_return(status: 409,
                   body: error_response_body.to_json,
                   headers: { 'Content-Type' => 'application/json' })
      DisqoApi.new.create_project_quota(project_id: 1, body: {})
    end
  end

  describe '#change_project_quota_status' do
    it 'changes a quota for a project to live' do
      stub_request(:put, "#{@url}/v1/clients/#{@client_id}/projects/1/quotas/1/status")
        .to_return(status: 201,
                   body: '',
                   headers: { 'Content-Type' => 'application/json' })
      assert_nil DisqoApi.new.change_project_quota_status(project_id: 1, quota_id: 1, status: 'LIVE')
    end

    it 'fails to change a quota for a project to live' do
      Rails.logger.expects(:error)
      stub_request(:put, "#{@url}/v1/clients/#{@client_id}/projects/1/quotas/1/status")
        .to_return(status: 409,
                   body: error_response_body.to_json,
                   headers: { 'Content-Type' => 'application/json' })
      DisqoApi.new.change_project_quota_status(project_id: 1, quota_id: 1, status: 'LIVE')
    end
  end

  private

  def error_response_body
    [
      {
        errorCode: '004',
        message: 'could not create project, id was already taken.'
      }
    ]
  end
end

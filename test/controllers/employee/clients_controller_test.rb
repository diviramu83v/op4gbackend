# frozen_string_literal: true

require 'test_helper'

class Employee::ClientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
  end

  it 'view client list' do
    get clients_url

    assert_response :ok
  end

  it 'view client page with no projects' do
    @client = clients(:basic)

    assert_empty @client.projects

    get client_url(@client)

    assert_response :ok
  end

  it 'view client page with projects' do
    @client = clients(:standard)

    assert_not_empty @client.projects

    get client_url(@client)

    assert_response :ok
  end

  it 'view new client page' do
    get new_client_url

    assert_response :ok
  end

  describe '#edit' do
    setup do
      @client = clients(:standard)
    end

    it 'should load the edit page' do
      get edit_client_url(@client)
    end
  end

  it 'create client' do
    client_params = { client: { name: 'New name' } }

    assert_difference -> { Client.count } do
      post clients_url, params: client_params
    end
  end

  it 'create client: missing name' do
    client_params = { client: { name: '' } }

    assert_no_difference -> { Client.count } do
      post clients_url, params: client_params
    end
  end

  describe '#update' do
    setup do
      @client = clients(:standard)
    end

    it 'should update a client' do
      client_params = { client: { name: 'New name' } }

      assert_no_difference -> { Client.count } do
        patch client_url(@client), params: client_params
      end

      assert_redirected_to client_url(@client)
    end

    it 'should fail to update a client' do
      client_params = { client: { name: '' } }

      assert_no_difference -> { Client.count } do
        patch client_url(@client), params: client_params
      end

      assert_template :edit
    end
  end
end

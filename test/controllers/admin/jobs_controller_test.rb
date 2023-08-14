# frozen_string_literal: true

require 'test_helper'

class Admin::JobsControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    load_and_sign_in_admin
  end

  it 'show job dashboard' do
    get jobs_url

    assert_response :ok
  end
end

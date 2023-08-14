# frozen_string_literal: true

require 'test_helper'

class Admin::EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_admin
  end

  it 'should show event list' do
    get events_url

    assert_response :ok
  end
end

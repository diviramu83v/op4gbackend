# frozen_string_literal: true

require 'test_helper'

class Employee::ApiCompletesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:admin)
    @vendor = vendors(:api)
  end

  describe '#index' do
    it 'should return the generated csv report' do
      get api_complete_url(@vendor, format: :csv)
      assert_response :ok
      assert_equal 'text/csv', response.content_type
    end
  end
end

# frozen_string_literal: true

require 'test_helper'

class Employee::NonprofitPanelistsControllerTest < ActionDispatch::IntegrationTest
  before do
    load_and_sign_in_recruitment_employee

    @nonprofit = nonprofits(:one)
  end

  describe '#index' do
    it 'should load the index page' do
      get nonprofit_panelists_url(@nonprofit)

      assert_response :ok
    end

    it 'returns a csv of the results' do
      get nonprofit_panelists_url(@nonprofit, format: :csv)

      assert_response :ok
    end
  end
end

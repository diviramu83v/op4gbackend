# frozen_string_literal: true

require 'test_helper'

class Employee::RecontactIdMatchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_employee(:admin)
    @recontact = surveys(:standard)
    @recontact.update!(category: :recontact)
  end

  describe '#show' do
    it 'should load the page' do
      get recontact_id_matches_url(@recontact)

      assert_response :ok
    end

    it 'renders the csv view' do
      get recontact_id_matches_url(@recontact, format: :csv)
      assert_equal controller.headers['Content-Transfer-Encoding'], 'binary'
    end
  end
end

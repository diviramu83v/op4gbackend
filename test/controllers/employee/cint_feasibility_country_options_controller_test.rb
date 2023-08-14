# frozen_string_literal: true

require 'test_helper'

class Employee::CintFeasibilityCountryOptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_admin
  end

  describe '#create' do
    setup do
      @demo_return_body = [
        {
          'id' => 4,
          'name' => 'Number of children',
          'text' => 'How many children under the age of 18 live in your household?',
          'categoryName' => 'Household',
          'variables' => [
            {
              'id' => 4,
              'name' => 'None'
            },
            {
              'id' => 5,
              'name' => 'One'
            }
          ]
        }
      ]
    end

    it 'should make api call to get countries' do
      CintApi.any_instance.expects(:country_demo_options).returns(@demo_return_body)

      post "#{cint_feasibility_country_options_url}.js", params: { country_id: 1 }
    end
  end
end

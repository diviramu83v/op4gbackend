# frozen_string_literal: true

require 'test_helper'

class Panelist::DemographicCategoriesControllerTest < ActionDispatch::IntegrationTest
  it 'gets the demographic category page' do
    load_and_sign_in_confirmed_panelist
    Panelist.any_instance.stubs(:unanswered_questions_for_category).returns([demo_questions(:standard)])

    @panelist.stubs(:demos_completed?).returns(false)

    get demographics_category_url('category slug')

    assert_ok_with_no_warning
  end
end

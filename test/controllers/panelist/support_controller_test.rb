# frozen_string_literal: true

require 'test_helper'

class Panelist::SupportControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_confirmed_panelist
  end

  it 'loads the support page' do
    get support_url

    assert_ok_with_no_warning
  end
end

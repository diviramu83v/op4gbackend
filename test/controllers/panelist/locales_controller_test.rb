# frozen_string_literal: true

require 'test_helper'

class Panelist::LocalesControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_confirmed_panelist
  end

  it 'should set the locale' do
    post locale_url, params: { settings: { locale: 'en' } }
    assert true # just make sure there are no errors in the post
  end
end

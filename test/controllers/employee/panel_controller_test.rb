# frozen_string_literal: true

require 'test_helper'

class Employee::PanelControllerTest < ActionDispatch::IntegrationTest
  setup do
    @employee = employees(:recruitment)
    sign_in(@employee)

    @panel = panels(:standard)
  end

  describe '#index' do
    it 'responds successfully' do
      get panels_url
      assert_response :ok
    end
  end

  it 'gets the panel#show page' do
    get panel_url(id: @panel.id)

    assert_response :ok
  end
end

# frozen_string_literal: true

require 'test_helper'

class TableData::PanelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @employee = employees(:admin)
    sign_in(@employee)
  end

  describe '#index' do
    it 'should load the page' do
      get table_data_panels_url

      assert_response :ok
    end
  end
end

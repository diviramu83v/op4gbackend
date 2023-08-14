# frozen_string_literal: true

require 'test_helper'

class Employee::DecodingDisqoControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
  end

  describe 'disqo show' do
    setup do
      @decoding = decodings(:standard)
    end

    it 'renders the html view' do
      get decoding_disqo_url(@decoding)
      assert_response :ok
    end

    it 'renders the csv view' do
      get decoding_disqo_url(@decoding, format: :csv)
      assert_equal controller.headers['Content-Transfer-Encoding'], 'binary'
    end
  end
end

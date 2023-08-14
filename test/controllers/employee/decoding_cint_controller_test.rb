# frozen_string_literal: true

require 'test_helper'

class DecodingCintControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_operations_employee
  end

  describe 'show' do
    setup do
      @decoding = decodings(:standard)
    end

    it 'renders the html view' do
      get decoding_cint_url(@decoding)
      assert_response :ok
    end

    it 'renders the csv view' do
      get decoding_cint_url(@decoding, format: :csv)
      assert_equal controller.headers['Content-Transfer-Encoding'], 'binary'
    end
  end
end

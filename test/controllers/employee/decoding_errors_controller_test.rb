# frozen_string_literal: true

require 'test_helper'

class Employee::DecodingErrorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
  end

  it 'sends a csv of failed decodings if the csv format is specified' do
    @decoding = decodings(:standard)
    get decoding_errors_url(@decoding, format: :csv)

    # check for csv response
    assert_equal controller.headers['Content-Transfer-Encoding'], 'binary'
  end

  it 'responds with nothing if the html format is specified' do
    @decoding = decodings(:standard)
    get decoding_errors_url(@decoding, format: :html)

    # check for csv response
    assert_ok_with_no_warning
  end
end

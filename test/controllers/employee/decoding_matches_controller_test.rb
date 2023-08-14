# frozen_string_literal: true

require 'test_helper'

class Employee::DecodingMatchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
  end

  describe 'IDs from a single project' do
    setup do
      @decoding = decodings(:standard)
      assert_not @decoding.multiple_projects?
    end

    it 'renders the html view' do
      get decoding_matches_url(@decoding)
      assert_response :ok
    end

    it 'renders the csv view' do
      get decoding_matches_url(@decoding, format: :csv)
      assert_equal controller.headers['Content-Transfer-Encoding'], 'binary'
    end
  end

  describe 'IDs from multiple projects' do
    setup do
      @decoding = decodings(:standard)
      Decoding.any_instance.stubs(:multiple_projects?).returns(true)
      assert @decoding.multiple_projects?
    end

    it 'renders the html view' do
      get decoding_matches_url(@decoding)
      assert_response :ok
    end

    it 'renders the csv view' do
      get decoding_matches_url(@decoding, format: :csv)
      assert_equal controller.headers['Content-Transfer-Encoding'], 'binary'
    end
  end
end

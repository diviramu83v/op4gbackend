# frozen_string_literal: true

require 'test_helper'

class Employee::DecodingTestingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @manager = employees(:operations)
    sign_in(@manager)

    @project = projects(:standard)
    @decoding = decodings(:standard)
  end

  describe '#show' do
    it 'responds successfully' do
      get decoding_testings_url(@decoding)
      assert_ok_with_no_warning
    end

    it 'handles decoding with multiple projects' do
      Decoding.any_instance.stubs(:multiple_projects?).returns(true)
      get decoding_testings_url(@decoding, format: :csv)
      assert_ok_with_no_warning
    end

    it 'handles decoding without multiple projects' do
      Decoding.any_instance.stubs(:multiple_projects?).returns(false)
      Decoding.any_instance.stubs(:projects).returns(Array(@project))

      get decoding_testings_url(@decoding, format: :csv)
      assert_ok_with_no_warning
    end
  end
end

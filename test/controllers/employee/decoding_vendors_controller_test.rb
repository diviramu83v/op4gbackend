# frozen_string_literal: true

require 'test_helper'

class Employee::DecodingVendorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @manager = employees(:operations)
    sign_in(@manager)

    @project = projects(:standard)
    @decoding = decodings(:standard)
    @processed_decoding = decodings(:standard)
    @vendor = vendors(:batch)
  end

  describe '#show' do
    it 'responds successfully' do
      get decoding_vendor_url(@decoding, @vendor)
      assert_ok_with_no_warning
    end

    it 'handles decoding with multiple projects' do
      Decoding.any_instance.stubs(:multiple_projects?).returns(true)

      get decoding_vendor_url(@decoding, @vendor, format: :csv)
      assert_ok_with_no_warning
    end

    it 'handles decoding without multiple projects' do
      Decoding.any_instance.stubs(:multiple_projects?).returns(false)
      Decoding.any_instance.stubs(:projects).returns(Array(@project))

      get decoding_vendor_url(@processed_decoding, @vendor, format: :csv)
      assert_ok_with_no_warning
    end
  end
end

# frozen_string_literal: true

require 'test_helper'

class Employee::CompletesDecoderDisqoQuotasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @manager = employees(:operations)
    sign_in(@manager)

    @project = projects(:standard)
    @decoding = completes_decoders(:standard)
    @disqo_quota = disqo_quotas(:standard)
  end

  describe '#show' do
    it 'handles decoding with multiple projects' do
      CompletesDecoder.any_instance.stubs(:multiple_projects?).returns(true)

      get completes_decoder_disqo_quota_url(@decoding, @disqo_quota, format: :csv)
      assert_ok_with_no_warning
    end

    it 'handles decoding without multiple projects' do
      CompletesDecoder.any_instance.stubs(:multiple_projects?).returns(false)
      CompletesDecoder.any_instance.stubs(:projects).returns(Array(@project))

      get completes_decoder_disqo_quota_url(@decoding, @disqo_quota, format: :csv)
      assert_ok_with_no_warning
    end
  end
end

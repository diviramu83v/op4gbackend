# frozen_string_literal: true

require 'test_helper'

class Employee::CompletesDecoderSurveysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @manager = employees(:operations)
    sign_in(@manager)

    @project = projects(:standard)
    @decoding = completes_decoders(:standard)
  end

  describe '#show' do
    it 'handles decoding a project' do
      CompletesDecoder.any_instance.stubs(:projects).returns(Array(@project))

      get completes_decoder_surveys_url(@decoding, format: :csv)
      assert_ok_with_no_warning
    end
  end
end

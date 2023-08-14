# frozen_string_literal: true

# View helpers for decodings.
module DecodingHelper
  def decoding_close_out_source_url(decoding, traffic_source, params)
    case traffic_source.class.name
    when 'Vendor'
      completes_decoder_vendor_url(decoding, traffic_source, params)
    when 'Panel'
      completes_decoder_panel_url(decoding, traffic_source, params)
    when 'DisqoQuota'
      completes_decoder_disqo_quota_url(decoding, traffic_source, params)
    when 'CintSurvey'
      completes_decoder_cint_survey_url(decoding, traffic_source, params)
    end
  end
end

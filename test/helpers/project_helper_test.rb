# frozen_string_literal: true

require 'test_helper'

class ProjectHelperTest < ActionView::TestCase
  describe '#project_close_out_details_link' do
    test 'returns proper result' do
      assert_equal survey_disqo_quotas_url(onramps(:disqo).survey), project_close_out_details_link(onramps(:disqo))
      assert_equal survey_cint_surveys_url(onramps(:cint).survey), project_close_out_details_link(onramps(:cint))
      assert_equal survey_vendors_url(onramps(:vendor).survey), project_close_out_details_link(onramps(:vendor))
    end
  end

  describe '#project_close_out_label' do
    setup do
      @project = projects(:standard)
      stub_request(:post, 'https://fuse.cint.com/fulfillment/respondents/Reconciliations')
        .to_return(status: 200, body: '', headers: {})
    end

    test 'returns proper result' do
      assert_equal 'waiting', project_close_out_label(@project.close_out_status)

      @project.update!(close_out_status: :finalized)

      assert_equal @project.close_out_status, project_close_out_label(@project.close_out_status)
    end
  end
end

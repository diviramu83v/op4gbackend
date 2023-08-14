# frozen_string_literal: true

require 'test_helper'

class DemographicDetailTest < ActiveSupport::TestCase
  def setup
    @demographic_detail = demographic_details(:standard)
  end

  describe '#create_result' do
    setup do
      @demographic_detail = demographic_details(:standard)
      @uid = '123'
      @panelist = panelists(:standard)
    end
    test 'creates demographic detail result' do
      assert_difference -> { DemographicDetailResult.count } do
        @demographic_detail.create_result(@uid, @panelist)
      end
    end
  end

  describe '#process_results' do
    setup do
      @demographic_detail = demographic_details(:standard)
    end
    test 'creates demographic detail result' do
      assert_difference -> { DemographicDetailResult.count } do
        @demographic_detail.process_results
      end
    end
  end
end

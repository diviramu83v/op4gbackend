# frozen_string_literal: true

require 'test_helper'

class DemoQueryTest < ActiveSupport::TestCase
  describe 'fixture' do
    it 'is valid' do
      demo_query = demo_queries(:standard)
      assert demo_query.valid?
      assert_empty demo_query.errors
    end
  end

  describe 'factories' do
    describe ':demo_query' do
      it 'is valid' do
        demo_query = demo_queries(:standard)
        assert demo_query.valid?
        assert_empty demo_query.errors
      end
    end

    describe ':live_demo_query' do
      it 'is valid' do
        demo_query = demo_queries(:standard)
        assert demo_query.valid?
        assert_empty demo_query.errors
      end
    end
  end

  describe 'methods' do
    before do
      @query = demo_queries(:simple)
      @panelist = panelists(:active)
      @panelist.panels << @query.panel
    end

    it 'panelist count changes when panelist suspended' do
      stub_request(:post, /madmimi.com/).to_return(status: 200, body: '', headers: {})

      assert @query.panelist_count.positive?

      assert_difference -> { @query.panelist_count }, -1 do
        @query.panelists.first.suspend
      end
    end

    it 'invitable panelist count changes when panelist suspended' do
      stub_request(:post, /madmimi.com/).to_return(status: 200, body: '', headers: {})

      assert @query.invitable_panelist_count.positive?

      assert_difference -> { @query.invitable_panelist_count }, -1 do
        @query.panelists.first.suspend
      end
    end
  end

  describe '#recent_studies_with_matching_query' do
    setup do
      @feasibility_query = demo_queries(:feasibility_query)
      @demo_query_two = demo_queries(:standard)
    end

    it 'should return any surveys that used a matching query' do
      assert_equal @feasibility_query.recent_studies_with_matching_query.first, @demo_query_two.survey
    end
  end
end

# frozen_string_literal: true

require 'test_helper'

class CompletsFunnelTest < ActiveSupport::TestCase
  setup do
    @campaign = recruiting_campaigns(:standard)
    @panel = panels(:standard)
    @nonprofit = nonprofits(:one)
    @affiliate = affiliates(:one)
  end

  describe '#total_invitations' do
    test 'campaign total_invitations count' do
      assert_instance_of Integer, @campaign.total_invitations
      assert_respond_to @campaign, :total_invitations
    end

    test 'panel total_invitations count' do
      assert_respond_to @panel, :total_invitations
    end

    test 'nonprofit total_invitations count' do
      assert_respond_to @nonprofit, :total_invitations
    end

    test 'affiliate total_invitations count' do
      assert_respond_to @affiliate, :total_invitations
    end
  end

  describe '#total_clicks' do
    test 'campaign total_clicks count' do
      assert_instance_of Integer, @campaign.total_clicks
      assert_respond_to @campaign, :total_clicks
    end

    test 'panel total_clicks count' do
      assert_respond_to @panel, :total_clicks
    end

    test 'nonprofit total_clicks count' do
      assert_respond_to @nonprofit, :total_clicks
    end

    test 'affiliate total_clicks count' do
      assert_respond_to @affiliate, :total_clicks
    end
  end

  describe '#total_completes' do
    test 'campaign total_completes count' do
      assert_instance_of Integer, @campaign.total_completes
      assert_respond_to @campaign, :total_completes
    end

    test 'panel total_completes count' do
      assert_respond_to @panel, :total_completes
    end

    test 'nonprofit total_completes count' do
      assert_respond_to @nonprofit, :total_completes
    end

    test 'affiliate total_completes count' do
      assert_respond_to @affiliate, :total_completes
    end
  end

  describe '#total_accepted_completes' do
    test 'campaign total_accepted_completes count' do
      assert_instance_of Integer, @campaign.total_accepted_completes
      assert_respond_to @campaign, :total_accepted_completes
    end

    test 'panel total_accepted_completes count' do
      assert_respond_to @panel, :total_accepted_completes
    end

    test 'nonprofit total_accepted_completes count' do
      assert_respond_to @nonprofit, :total_accepted_completes
    end

    test 'affiliate total_accepted_completes count' do
      assert_respond_to @affiliate, :total_accepted_completes
    end
  end

  describe '#total_completers' do
    test 'campaign total_completers count' do
      assert_instance_of Integer, @campaign.total_completers
      assert_respond_to @campaign, :total_completers
    end

    test 'panel total_completers count' do
      assert_respond_to @panel, :total_completers
    end

    test 'nonprofit total_completers count' do
      assert_respond_to @nonprofit, :total_completers
    end

    test 'affiliate total_completers count' do
      assert_respond_to @affiliate, :total_completers
    end
  end

  describe '#total_uninvited_panelists' do
    test 'campaign total_uninvited_panelists count' do
      assert_instance_of Integer, @campaign.total_uninvited_panelists
      assert_respond_to @campaign, :total_uninvited_panelists
    end

    test 'panel total_uninvited_panelists count' do
      assert_respond_to @panel, :total_uninvited_panelists
    end

    test 'nonprofit total_uninvited_panelists count' do
      assert_respond_to @nonprofit, :total_uninvited_panelists
    end

    test 'affiliate total_uninvited_panelists count' do
      assert_respond_to @affiliate, :total_uninvited_panelists
    end
  end

  describe '#pull_completes_funnel_data' do
    test 'campaign pull_completes_funnel_data' do
      CompletesFunnelChannel.expects(:broadcast_to).once
      @campaign.pull_completes_funnel_data
    end

    test 'panel pull_completes_funnel_data' do
      CompletesFunnelChannel.expects(:broadcast_to).once
      @panel.pull_completes_funnel_data
    end

    test 'nonprofit pull_completes_funnel_data' do
      CompletesFunnelChannel.expects(:broadcast_to).once
      @nonprofit.pull_completes_funnel_data
    end

    test 'affiliate pull_completes_funnel_data' do
      CompletesFunnelChannel.expects(:broadcast_to).once
      @affiliate.pull_completes_funnel_data
    end
  end
end

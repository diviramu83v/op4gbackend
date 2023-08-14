# frozen_string_literal: true

require 'test_helper'

class PanelistTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  describe '#add_signup_earnings' do
    describe 'related campaign' do
      describe 'positive incentive' do
        setup do
          campaign = recruiting_campaigns(:standard)
          campaign.update!(incentive: 7)
          @panelist = panelists(:standard)
          @panelist.update(campaign: campaign)
        end

        it 'adds an earning record' do
          assert_difference -> { Earning.count }, 1 do
            @panelist.add_signup_earnings
          end
        end
      end

      describe 'negative incentive' do
        setup do
          campaign = recruiting_campaigns(:standard)
          campaign.update!(incentive: -7)
          @panelist = panelists(:standard)
          @panelist.update(campaign: campaign)
        end

        it 'does not add an earning record' do
          assert_no_difference -> { Earning.count } do
            @panelist.add_signup_earnings
          end
        end
      end

      describe '0 incentive' do
        setup do
          campaign = recruiting_campaigns(:standard)
          campaign.update!(incentive: 0)
          @panelist = panelists(:standard)
          @panelist.update(campaign: campaign)
        end

        it 'does not add an earning record' do
          assert_no_difference -> { Earning.count } do
            @panelist.add_signup_earnings
          end
        end
      end

      describe 'nil incentive' do
        setup do
          campaign = recruiting_campaigns(:standard)
          campaign.update!(incentive: nil)
          @panelist = panelists(:standard)
          @panelist.update(campaign: campaign)
        end

        it 'does not add an earning record' do
          assert_no_difference -> { Earning.count } do
            @panelist.add_signup_earnings
          end
        end
      end
    end

    describe 'related panel' do
      describe 'positive incentive' do
        setup do
          panel = panels(:standard)
          panel.update(incentive: 7)
          @panelist = panelists(:standard)
        end

        it 'adds an earning record' do
          assert_difference -> { Earning.count }, 1 do
            @panelist.add_signup_earnings
          end
        end
      end

      describe 'negative incentive' do
        setup do
          panel = panels(:standard)
          panel.update(incentive: -7)
          @panelist = panelists(:standard)
        end

        it 'does not add an earning record' do
          assert_no_difference -> { Earning.count } do
            @panelist.add_signup_earnings
          end
        end
      end

      describe '0 incentive' do
        setup do
          panel = panels(:standard)
          panel.update(incentive: 0)
          @panelist = panelists(:standard)
        end

        it 'does not add an earning record' do
          assert_no_difference -> { Earning.count } do
            @panelist.add_signup_earnings
          end
        end
      end

      describe 'nil incentive' do
        setup do
          panel = panels(:standard)
          panel.update(incentive: nil)
          @panelist = panelists(:standard)
        end

        it 'does not add an earning record' do
          assert_no_difference -> { Earning.count } do
            @panelist.add_signup_earnings
          end
        end
      end
    end
  end

  describe 'supporting_nonprofit' do
    it 'returns true if the panelist belongs to a nonprofit' do
      panelist = panelists(:active)

      assert panelist.supporting_nonprofit?
    end

    it 'returns false if the panelist does not belong to a nonprofit' do
      panelist = panelists(:standard)

      assert_not panelist.supporting_nonprofit?
    end
  end

  describe 'private: set_donation_percentage' do
    describe 'without nonprofit' do
      it 'sets the donation percentage to 0' do
        @panelist = panelists(:standard)
        @panelist.update(nonprofit: nil)
        assert_equal 0, @panelist.donation_percentage
      end
    end

    describe 'with nonprofit' do
      setup do
        @panelist = panelists(:standard)
        @panelist.update(nonprofit: nonprofits(:one))
      end

      it 'sets the donation percentage to 100' do
        assert_equal 100, @panelist.donation_percentage
      end

      describe 'removing nonprofit' do
        setup do
          @panelist.update(nonprofit: nil)
        end

        it 'sets the donation percentage to 0' do
          assert_equal 0, @panelist.donation_percentage
        end
      end
    end
  end
end

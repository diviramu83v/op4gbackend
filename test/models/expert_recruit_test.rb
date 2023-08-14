# frozen_string_literal: true

require 'test_helper'

class ExpertRecruitTest < ActiveSupport::TestCase
  describe 'fixture' do
    setup do
      @expert_recruit = expert_recruits(:standard)
    end

    it 'is valid' do
      @expert_recruit.valid?
      assert_empty @expert_recruit.errors
    end
  end

  describe 'methods' do
    setup do
      @expert_recruit = expert_recruits(:standard)
    end

    test '#clicked!' do
      assert_nil @expert_recruit.clicked_at

      @expert_recruit.clicked!

      assert_not_nil @expert_recruit.clicked_at
    end

    test '#unsubscribed?' do
      assert_equal false, @expert_recruit.unsubscribed?

      ExpertRecruitUnsubscription.create(email: @expert_recruit.email, expert_recruit: @expert_recruit)

      assert_equal true, @expert_recruit.unsubscribed?
    end

    test '#unsubscribed? if expert recruit is an unsubscribed panelist' do
      @expert_recruit = panelists(:standard)
      assert_equal false, @expert_recruit.unsubscribed?

      Unsubscription.create!(email: @expert_recruit.email, panelist: @expert_recruit)

      assert_equal true, @expert_recruit.unsubscribed?
    end
  end
end

# frozen_string_literal: true

require 'test_helper'

class TrafficEventTest < ActiveSupport::TestCase
  describe 'attributes' do
    subject { traffic_events(:standard) }

    should have_db_column(:category)
    should have_db_column(:message)
  end

  describe 'associations' do
    subject { traffic_events(:standard) }

    should belong_to(:onboarding)
  end

  describe 'validations' do
    subject { traffic_events(:standard) }

    should validate_presence_of(:category)
    should validate_presence_of(:message)

    describe 'category' do
      it 'is valid if it is in the category list' do
        subject.category = 'fraud'

        assert subject.valid?
      end

      it 'is not valid if it is not in the category list' do
        subject.category = 'not in list'

        assert_not subject.valid?
      end
    end
  end

  describe 'scopes' do
    describe '.fraudulent' do
      subject { TrafficEvent.fraudulent }

      it 'includes records with the fraud category' do
        assert_difference -> { subject.count } do
          TrafficEvent.create!(onboarding: onboardings(:standard), category: 'fraud', message: 'generic message')
        end
      end

      it 'ignores records with a non-fraud category' do
        assert_no_difference -> { subject.count } do
          TrafficEvent.create!(onboarding: onboardings(:standard), category: 'info', message: 'generic message')
        end
      end
    end
  end

  describe '.suspicious' do
    subject { TrafficEvent.suspicious }

    it 'includes records with the suspicious category' do
      assert_difference -> { subject.count } do
        TrafficEvent.create!(onboarding: onboardings(:standard), category: 'suspicious', message: 'generic message')
      end
    end

    it 'ignores records with a non-fraud category' do
      assert_no_difference -> { subject.count } do
        TrafficEvent.create!(onboarding: onboardings(:standard), category: 'info', message: 'generic message')
      end
    end
  end
end

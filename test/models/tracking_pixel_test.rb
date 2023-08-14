# frozen_string_literal: true

require 'test_helper'

class TrackingPixelTest < ActiveSupport::TestCase
  describe 'attributes' do
    subject { tracking_pixels(:standard) }

    should have_db_column(:url)
    should have_db_column(:category)
  end

  describe 'validations' do
    subject { tracking_pixels(:standard) }

    should validate_presence_of(:url)
    should validate_presence_of(:category)

    describe 'category' do
      it 'is valid if it is in the category list' do
        subject.category = 'welcome'

        assert subject.valid?
      end

      it 'is not valid if it is not in the category list' do
        subject.category = 'not in list'

        assert_not subject.valid?
      end
    end
  end

  describe 'scopes' do
    describe '.confirmation' do
      subject { TrackingPixel.confirmation }

      it 'includes records with the confirmation category' do
        assert_difference -> { subject.confirmation.count } do
          TrackingPixel.create!(url: 'https://test.com', category: 'confirmation')
        end
      end

      it 'ignores records with a non-confirmation category' do
        assert_no_difference -> { subject.confirmation.count } do
          TrackingPixel.create!(url: 'https://test.com', category: 'welcome')
        end
      end
    end

    describe '.welcome' do
      subject { TrackingPixel.welcome }

      it 'includes records with the welcome category' do
        assert_difference -> { subject.welcome.count } do
          TrackingPixel.create!(url: 'https://test.com', category: 'welcome')
        end
      end

      it 'ignores records with a non-welcome category' do
        assert_no_difference -> { subject.welcome.count } do
          TrackingPixel.create!(url: 'https://test.com', category: 'confirmation')
        end
      end
    end
  end
end

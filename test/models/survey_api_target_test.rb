# frozen_string_literal: true

require 'test_helper'

class SurveyApiTargetTest < ActiveSupport::TestCase
  include SurveyApiTargetHelper

  describe 'fixture' do
    it 'is valid' do
      target = survey_api_targets(:standard)
      assert target.valid?
      assert_empty target.errors
    end
  end

  describe 'callbacks' do
    describe 'after_commit' do
      describe '#add_onramps' do
        setup do
          @target_attributes = survey_api_targets(:standard).attributes

          @survey = surveys(:standard)
          DemoQueryOnboarding.destroy_all
          Earning.destroy_all
          @survey.onramps.each(&:destroy!)
          @survey.survey_api_target.destroy!
        end

        describe 'active target' do
          it 'automatically adds an onramp' do
            assert_difference 'Onramp.api.count' do
              SurveyApiTarget.create!(
                @target_attributes.merge(survey: @survey, status: 'active').except(:id)
              )
            end
          end
        end

        describe 'sandbox target' do
          it 'automatically adds an onramp' do
            assert_difference 'Onramp.api.count' do
              SurveyApiTarget.create!(
                @target_attributes.merge(survey: @survey, status: 'sandbox').except(:id)
              )
            end
          end
        end

        describe 'inactive target' do
          it 'does not add an onramp' do
            assert_no_difference 'Onramp.api.count' do
              SurveyApiTarget.create!(
                @target_attributes.merge(survey: @survey, status: 'inactive').except(:id)
              )
            end
          end
        end
      end
    end
  end

  describe 'payout' do
    it 'returns valid payout amounts in dollars' do
      target = survey_api_targets(:standard)
      original_payout = target.payout

      target.payout = nil
      assert_equal target.payout, original_payout
      target.payout = 'a'
      assert_equal target.payout, original_payout
      target.payout = '4'
      assert_equal target.payout, 4
      target.payout = '1.5'
      assert_equal target.payout, 1.5
    end
  end

  describe 'set_age_range' do
    it 'returns the range if the range is not full, else it returns nil for a full range' do
      target = survey_api_targets(:standard)
      target.min_age = SurveyApiTarget::MIN_AGE
      target.max_age = SurveyApiTarget::MAX_AGE
      target.save!

      assert target.age_range.nil?
      target.max_age -= 1
      target.save!
      assert_equal target.age_range.length, 85
    end
  end

  describe 'formatted_age_range' do
    it 'returns the correct range string' do
      target = survey_api_targets(:standard)
      assert_equal formatted_age_range(target), "#{target.min_age} - #{target.max_age}"

      old_max_age = target.max_age
      target.max_age = nil
      assert_equal formatted_age_range(target), "#{target.min_age} +"

      target.max_age = old_max_age
      target.min_age = nil
      assert_equal formatted_age_range(target), "< #{target.max_age}"
    end
  end
end

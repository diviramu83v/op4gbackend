# frozen_string_literal: true

require 'test_helper'

class SurveyAdjustmentTest < ActiveSupport::TestCase
  describe 'fabricator' do
    subject { survey_adjustments(:standard) }

    it 'is valid' do
      assert subject.valid?
    end
  end

  describe 'validations' do
    subject { survey_adjustments(:standard) }

    should belong_to(:survey)
    should validate_presence_of(:offset)
    should validate_numericality_of(:offset), only_integer: true

    describe 'offset' do
      it 'allows positive values' do
        subject.update!(offset: 1)
        assert subject.valid?
      end

      it 'allows negative values' do
        subject.update!(offset: -1)
        assert subject.valid?
      end

      it 'does not allow zero values' do
        subject.update(offset: 0)
        assert_not subject.valid?
      end
    end
  end
end

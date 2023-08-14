# frozen_string_literal: true

require 'test_helper'

class SystemEventSummaryTest < ActiveSupport::TestCase
  describe 'validations' do
    subject { system_event_summaries(:standard) }

    should validate_presence_of(:day_happened_at)
    should validate_presence_of(:action)
    should validate_presence_of(:count)
  end
end

# frozen_string_literal: true

require 'test_helper'

class KeyTest < ActiveSupport::TestCase
  describe 'key creation' do
    setup do
      @survey = surveys(:standard)
      @key_attrs = { survey: @survey, value: 'TESTKEYVALUE' }
    end

    it 'creates a new record' do
      assert_difference ['Key.count'] do
        Key.create!(@key_attrs)
      end
    end
  end
end
